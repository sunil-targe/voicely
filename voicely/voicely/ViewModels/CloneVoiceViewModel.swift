import Foundation
import AVFoundation
import SwiftUI

class CloneVoiceViewModel: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var recordingTime: TimeInterval = 0
    @Published var currentScriptIndex = 0
    @Published var isCloning = false
    @Published var cloneProgress: String = ""
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var hasRecordedAudio = false
    @Published var showPermissionDenied = false
    @Published var cloneSuccess = false
    @Published var clonedVoiceName = ""
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingTimer: Timer?
    private var scriptTimer: Timer?
    private var recordedAudioData: Data?
    private let cloneService = CloneService()
    private let clonedVoiceStorage = ClonedVoiceStorage.shared
    
    // Script for voice cloning - user needs to read this aloud
    let cloneScript = [
        "Hi there,",
        "I'm recording a short voice sample,",
        "and in just a moment,",
        "my voice will begin reading a story out loud",
        "with the help of Voicely."
    ]
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    deinit {
        stopRecording()
        recordingTimer?.invalidate()
        scriptTimer?.invalidate()
    }
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Permission Handling
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    completion(true)
                } else {
                    self.showPermissionDenied = true
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Recording Functions
    func startRecording() {
        guard !isRecording else { return }
        
        requestMicrophonePermission { [weak self] granted in
            guard granted else { return }
            
            DispatchQueue.main.async {
                self?.beginRecording()
            }
        }
    }
    
    private func beginRecording() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("voice_clone_recording.wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false
        ] as [String: Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            isRecording = true
            recordingTime = 0
            currentScriptIndex = 0
            hasRecordedAudio = false
            
            // Start recording timer
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.recordingTime += 0.1
            }
            
            // Start script highlighting timer
            startScriptHighlighting()
            
        } catch {
            showError(message: "Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    private func startScriptHighlighting() {
        scriptTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.currentScriptIndex < self.cloneScript.count - 1 {
                self.currentScriptIndex += 1
            } else {
                // Reset to beginning and continue cycling
                self.currentScriptIndex = 0
            }
        }
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        audioRecorder?.stop()
        recordingTimer?.invalidate()
        scriptTimer?.invalidate()
        isRecording = false
        
        // Load recorded audio data
        if let audioRecorder = audioRecorder {
            do {
                recordedAudioData = try Data(contentsOf: audioRecorder.url)
                hasRecordedAudio = true
            } catch {
                showError(message: "Failed to load recorded audio: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Voice Cloning
    func startVoiceCloning() {
        guard let audioData = recordedAudioData else {
            showError(message: "No recorded audio available")
            return
        }
        
        guard !clonedVoiceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError(message: "Please enter a name for your cloned voice")
            return
        }
        
        isCloning = true
        cloneProgress = "Uploading your voice..."
        
        cloneService.cloneVoice(audioData: audioData) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleCloneResult(result)
            }
        }
    }
    
    private func handleCloneResult(_ result: Result<String, Error>) {
        switch result {
        case .success(let voiceID):
            cloneProgress = "Voice cloned successfully!"
            
            // Create cloned voice object
            let clonedVoice = ClonedVoice(
                id: UUID(),
                name: clonedVoiceName.trimmingCharacters(in: .whitespacesAndNewlines),
                voiceID: voiceID,
                audioData: recordedAudioData ?? Data(),
                createdAt: Date()
            )
            
            // Save to storage
            clonedVoiceStorage.saveClonedVoice(clonedVoice)
            
            // Show success
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.cloneSuccess = true
                self.isCloning = false
            }
            
        case .failure(let error):
            isCloning = false
            showError(message: "Voice cloning failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Playback
    func playRecordedAudio() {
        guard let audioData = recordedAudioData else { return }
        
        do {
            let audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer.play()
        } catch {
            showError(message: "Failed to play recorded audio: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Reset
    func resetRecording() {
        stopRecording()
        recordedAudioData = nil
        hasRecordedAudio = false
        recordingTime = 0
        currentScriptIndex = 0
        clonedVoiceName = ""
        cloneSuccess = false
    }
    
    // MARK: - Error Handling
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    // MARK: - Computed Properties
    var formattedRecordingTime: String {
        let minutes = Int(recordingTime) / 60
        let seconds = Int(recordingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var canStartCloning: Bool {
        return hasRecordedAudio && !clonedVoiceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isCloning
    }
}

// MARK: - AVAudioRecorderDelegate
extension CloneVoiceViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            showError(message: "Recording failed")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            showError(message: "Recording error: \(error.localizedDescription)")
        }
    }
}

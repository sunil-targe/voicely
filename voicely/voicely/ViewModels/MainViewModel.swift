import Foundation
import AVFoundation
import Amplitude

class MainViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var selectedVoice: Voice
    @Published var generatedAudioURL: URL?
    @Published var generatedLocalAudioFilename: String?
    @Published var isLoading: Bool = false
    @Published var history: [HistoryItem] = []
    
    private let speechService = SpeechService()
    
    init(selectedVoice: Voice) {
        // Load last selection if available
        let last = AppStorageManager.shared.loadVoiceSelection()
        var initialVoice = selectedVoice
        if let voiceID = last.voiceID, let match = Voice.all.first(where: { $0.voice_id == voiceID }) {
            initialVoice = match
        }
        if let emotion = last.emotion { initialVoice.emotion = emotion }
        if let language = last.language { initialVoice.language = language }
        if let channel = last.channel { initialVoice.channel = channel }
        self.selectedVoice = initialVoice
        self.history = HistoryStorage.load()
    }
    
    func generateSpeech(emotion: String, channel: String, languageBoost: String) {
        guard !inputText.isEmpty else { return }
        isLoading = true
        generatedAudioURL = nil
        generatedLocalAudioFilename = nil
        speechService.generateSpeech(text: inputText, voiceID: selectedVoice.voice_id, emotion: emotion, channel: channel, languageBoost: languageBoost) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let url):
                // Download and save mp3 in background
                DispatchQueue.global(qos: .background).async {
                    let localFilename = Self.downloadAndSaveAudio(from: url)
                    DispatchQueue.main.async {
                        self?.generatedAudioURL = url
                        self?.generatedLocalAudioFilename = localFilename
                        let item = HistoryItem(
                            id: UUID(),
                            text: self?.inputText ?? "",
                            voice: self?.selectedVoice ?? Voice.default,
                            audioURL: url,
                            localAudioFilename: localFilename,
                            date: Date(),
                            emotion: emotion,
                            language: languageBoost,
                            channel: channel
                        )
                        self?.history.insert(item, at: 0)
                        HistoryStorage.save(self?.history ?? [])
                        RatingPromptManager.shared.requestReviewIfAppropriate()
                        Amplitude.instance().logEvent(
                            "event_voice_generated",
                            withEventProperties: [
                                "voice_id": self?.selectedVoice.voice_id ?? "",
                                "emotion": emotion,
                                "languageBoost": languageBoost,
                                "channel": channel,
                                "input_text_length": self?.inputText.count ?? 0
                            ]
                        )
                    }
                }
            case .failure(let error):
                print("Speech generation failed: \(error)")
            }
        }
    }

    private static func downloadAndSaveAudio(from remoteURL: URL) -> String? {
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestamp = formatter.string(from: Date())
        let filename = "voicely_audio_\(timestamp).mp3"
        let localURL = docs.appendingPathComponent(filename)
        do {
            print("Downloading audio from: \(remoteURL)")
            let data = try Data(contentsOf: remoteURL)
            print("Downloaded data size: \(data.count) bytes")
            try data.write(to: localURL)
            print("Saved audio to: \(localURL.path)")
            return filename
        } catch {
            print("Failed to download or save audio: \(error)")
            return nil
        }
    }

    // Save selection whenever selectedVoice or its properties change
    func updateVoiceSelection() {
        AppStorageManager.shared.saveVoiceSelection(
            voiceID: selectedVoice.voice_id,
            emotion: selectedVoice.emotion,
            language: selectedVoice.language,
            channel: selectedVoice.channel
        )
    }
}

struct HistoryItem: Identifiable, Codable {
    let id: UUID
    let text: String
    let voice: Voice
    let audioURL: URL
    let localAudioFilename: String?
    let date: Date
    let emotion: String
    let language: String
    let channel: String
} 

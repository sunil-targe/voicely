import Foundation
import AVFoundation

class SoundscapeAudioManager: ObservableObject {
    static let shared = SoundscapeAudioManager()
    
    @Published var isPlaying: Bool = false
    @Published var currentSoundscape: SoundscapesView.SoundscapeType = .mute
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func playSoundscape(_ soundscape: SoundscapesView.SoundscapeType) {
        // Don't play anything for mute
        if soundscape == .mute {
            stopSoundscape()
            currentSoundscape = .mute
            isPlaying = false
            return
        }
        
        // Stop current audio if playing
        stopSoundscape()
        
        // Get the audio file name based on soundscape type
        let fileName = getAudioFileName(for: soundscape)
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Resources/whitenoise") else {
            print("Could not find audio file for \(soundscape): \(fileName).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = 0.3 // Set volume to 30%
            audioPlayer?.play()
            
            currentSoundscape = soundscape
            isPlaying = true
            
            print("Playing soundscape: \(soundscape) - \(fileName).mp3")
        } catch {
            print("Failed to play soundscape \(soundscape): \(error)")
        }
    }
    
    func stopSoundscape() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    private func getAudioFileName(for soundscape: SoundscapesView.SoundscapeType) -> String {
        switch soundscape {
        case .mute:
            return ""
        case .nature:
            return "nature"
        case .water:
            return "water"
        case .music:
            return "brown" // Using brown.mp3 for music as there's no music.mp3
        case .coffee:
            return "coffee"
        case .fire:
            return "fire"
        case .sparkle:
            return "sparkle"
        case .clock:
            return "clock"
        }
    }
    
    func cleanup() {
        stopSoundscape()
    }
}

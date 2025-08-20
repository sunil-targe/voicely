import Foundation
import AVFoundation

class AudioSessionManager {
    static let shared = AudioSessionManager()
    
    private init() {}
    
    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            // Set category for background playback with mixing to allow multiple audio streams
            try audioSession.setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP, .mixWithOthers])
            
            // Set active
            try audioSession.setActive(true)
            
            print("Audio session configured for background playback with mixing")
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
    }
    
    func configureAudioSessionForSoundscape() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            // Configure for soundscape playback with mixing
            try audioSession.setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP, .mixWithOthers])
            
            // Set active
            try audioSession.setActive(true)
            
            print("Audio session configured for soundscape playback with mixing")
        } catch {
            print("Failed to configure audio session for soundscape: \(error)")
        }
    }
} 
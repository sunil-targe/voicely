import Foundation
import SwiftUI

// MARK: - Cloned Voice Model
struct ClonedVoice: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let voiceID: String // The voice_id returned from Replicate API
    let audioData: Data // Original recording data for playback preview
    let createdAt: Date
    var emotion: String = "auto"
    var language: String = "Automatic"
    var channel: String = "mono"
    
    // Convert to Voice model for compatibility with existing system
    func toVoice() -> Voice {
        return Voice(
            id: self.id,
            name: self.name,
            description: "Your cloned voice",
            color: ColorCodable(color: Color(red: 0.6, green: 0.8, blue: 1.0)), // Light blue for cloned voices
            voice_id: self.voiceID,
            emotion: self.emotion,
            language: self.language,
            channel: self.channel,
            preferredListenTime: "anytime"
        )
    }
}

// MARK: - Cloned Voice Storage Manager
class ClonedVoiceStorage: ObservableObject {
    static let shared = ClonedVoiceStorage()
    @Published var clonedVoices: [ClonedVoice] = []
    
    private let filename = "cloned_voices.json"
    
    private var fileURL: URL {
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(filename)
    }
    
    private init() {
        loadClonedVoices()
    }
    
    func saveClonedVoice(_ clonedVoice: ClonedVoice) {
        clonedVoices.insert(clonedVoice, at: 0) // Add to beginning so it appears first
        saveToFile()
    }
    
    func deleteClonedVoice(_ clonedVoice: ClonedVoice) {
        clonedVoices.removeAll { $0.id == clonedVoice.id }
        saveToFile()
    }
    
    func deleteClonedVoice(withID id: UUID) {
        clonedVoices.removeAll { $0.id == id }
        saveToFile()
    }
    
    private func saveToFile() {
        do {
            let data = try JSONEncoder().encode(clonedVoices)
            #if os(iOS)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            #else
            try data.write(to: fileURL, options: .atomic)
            #endif
            print("ClonedVoiceStorage: Saved \(clonedVoices.count) cloned voices to \(fileURL.path)")
        } catch {
            print("Failed to save cloned voices: \(error)")
        }
    }
    
    private func loadClonedVoices() {
        do {
            let data = try Data(contentsOf: fileURL)
            clonedVoices = try JSONDecoder().decode([ClonedVoice].self, from: data)
            print("ClonedVoiceStorage: Loaded \(clonedVoices.count) cloned voices from \(fileURL.path)")
        } catch {
            print("Failed to load cloned voices (this is normal on first run): \(error)")
            clonedVoices = []
        }
    }
    
    func hasClonedVoices() -> Bool {
        return !clonedVoices.isEmpty
    }
    
    // Update a cloned voice's settings
    func updateClonedVoice(_ clonedVoice: ClonedVoice) {
        if let index = clonedVoices.firstIndex(where: { $0.id == clonedVoice.id }) {
            clonedVoices[index] = clonedVoice
            saveToFile()
        }
    }
}

import Foundation
import AVFoundation
import Amplitude

/// StoryViewModel handles story voice generation, storage, and playback functionality
/// Similar to MainViewModel but specifically designed for story content
class StoryViewModel: ObservableObject {
    @Published var selectedVoice: Voice
    @Published var generatedAudioURL: URL?
    @Published var generatedLocalAudioFilename: String?
    @Published var isLoading: Bool = false
    @Published var savedStories: [SavedStory] = []
    @Published var errorMessage: String?
    
    private let speechService = SpeechService()
    
    init(selectedVoice: Voice = Voice.default) {
        self.selectedVoice = selectedVoice
        // Load saved stories immediately
        self.savedStories = StoryStorage.load()
        print("StoryViewModel: Loaded \(self.savedStories.count) saved stories")
        for story in self.savedStories {
            print("StoryViewModel: Found saved story - \(story.story.name) with voice \(story.voice.name)")
        }
    }
    
    /// Generates voice for a story using the provided voice settings
    /// - Parameters:
    ///   - story: The story to generate voice for
    ///   - voice: The voice to use for generation
    func generateStoryVoice(for story: Story, with voice: Voice) {
        guard !story.fullStoryContent.isEmpty else { 
            errorMessage = "Story content is empty"
            return 
        }
        
        isLoading = true
        generatedAudioURL = nil
        generatedLocalAudioFilename = nil
        errorMessage = nil
        
        speechService.generateSpeech(
            text: story.fullStoryContent,
            voiceID: voice.voice_id,
            emotion: voice.emotion,
            channel: voice.channel,
            languageBoost: voice.language
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let url):
                    // Download and save mp3 in background
                    DispatchQueue.global(qos: .background).async {
                        let localFilename = Self.downloadAndSaveAudio(from: url, storyName: story.storyViewName)
                        DispatchQueue.main.async {
                            self?.generatedAudioURL = url
                            self?.generatedLocalAudioFilename = localFilename
                            
                            // Create and save the story
                            let savedStory = SavedStory(
                                id: UUID(),
                                story: story,
                                voice: voice,
                                audioURL: url,
                                localAudioFilename: localFilename,
                                date: Date(),
                                emotion: voice.emotion,
                                language: voice.language,
                                channel: voice.channel
                            )
                            
                            // Check if story already exists and update it
                            if let existingIndex = self?.savedStories.firstIndex(where: { $0.story.id == story.id }) {
                                self?.savedStories[existingIndex] = savedStory
                                print("StoryViewModel: Updated existing story - \(story.name)")
                            } else {
                                self?.savedStories.insert(savedStory, at: 0)
                                print("StoryViewModel: Added new saved story - \(story.name)")
                            }
                            
                            StoryStorage.save(self?.savedStories ?? [])
                            print("StoryViewModel: Saved \(self?.savedStories.count ?? 0) stories to storage")
                            
                            // Analytics
                            Amplitude.instance().logEvent(
                                "event_story_voice_generated",
                                withEventProperties: [
                                    "story_name": story.name,
                                    "story_view_name": story.storyViewName,
                                    "voice_id": voice.voice_id,
                                    "emotion": voice.emotion,
                                    "languageBoost": voice.language,
                                    "channel": voice.channel,
                                    "story_content_length": story.fullStoryContent.count
                                ]
                            )
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to generate story voice: \(error.localizedDescription)"
                    print("Story voice generation failed: \(error)")
                }
            }
        }
    }
    
    /// Gets the saved story for a given story
    /// - Parameter story: The story to look for
    /// - Returns: The saved story if it exists, nil otherwise
    func getSavedStory(for story: Story) -> SavedStory? {
        let savedStory = savedStories.first { $0.story.id == story.id }
        print("StoryViewModel: Looking for saved story - \(story.name), found: \(savedStory != nil)")
        return savedStory
    }
    
    /// Checks if a story has been saved with generated voice
    /// - Parameter story: The story to check
    /// - Returns: True if the story has been saved, false otherwise
    func hasSavedStory(for story: Story) -> Bool {
        let hasStory = getSavedStory(for: story) != nil
        print("StoryViewModel: Has saved story for \(story.name): \(hasStory)")
        return hasStory
    }
    
    /// Gets the local audio URL for a saved story
    /// - Parameter savedStory: The saved story to get audio for
    /// - Returns: The local audio URL if the file exists, nil otherwise
    func getLocalAudioURL(for savedStory: SavedStory) -> URL? {
        guard let filename = savedStory.localAudioFilename else { 
            print("StoryViewModel: No local filename for saved story")
            return nil 
        }
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let localURL = docs.appendingPathComponent(filename)
        let exists = fileManager.fileExists(atPath: localURL.path)
        print("StoryViewModel: Local audio file exists for \(savedStory.story.name): \(exists)")
        return exists ? localURL : nil
    }
    
    /// Downloads and saves audio file with a unique name based on story
    /// - Parameters:
    ///   - remoteURL: The remote URL to download from
    ///   - storyName: The story name to use in the filename
    /// - Returns: The local filename if successful, nil otherwise
    private static func downloadAndSaveAudio(from remoteURL: URL, storyName: String) -> String? {
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestamp = formatter.string(from: Date())
        let filename = "story_\(storyName)_\(timestamp).mp3"
        let localURL = docs.appendingPathComponent(filename)
        
        do {
            print("Downloading story audio from: \(remoteURL)")
            let data = try Data(contentsOf: remoteURL)
            print("Downloaded story data size: \(data.count) bytes")
            try data.write(to: localURL)
            print("Saved story audio to: \(localURL.path)")
            return filename
        } catch {
            print("Failed to download or save story audio: \(error)")
            return nil
        }
    }
    
    /// Saves voice selection to persistent storage
    func updateVoiceSelection() {
        AppStorageManager.shared.saveVoiceSelection(
            voiceID: selectedVoice.voice_id,
            emotion: selectedVoice.emotion,
            language: selectedVoice.language,
            channel: selectedVoice.channel
        )
    }
}

// MARK: - SavedStory Model
/// Represents a story that has been saved with generated voice
struct SavedStory: Identifiable, Codable {
    let id: UUID
    let story: Story
    let voice: Voice
    let audioURL: URL
    let localAudioFilename: String?
    let date: Date
    let emotion: String
    let language: String
    let channel: String
}

// MARK: - StoryStorage
/// Handles persistent storage for saved stories
struct StoryStorage {
    static let filename = "saved_stories.json"
    
    static var fileURL: URL {
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(filename)
    }
    
    /// Saves saved stories to persistent storage
    /// - Parameter savedStories: Array of saved stories to save
    static func save(_ savedStories: [SavedStory]) {
        do {
            let data = try JSONEncoder().encode(savedStories)
            #if os(iOS)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            #else
            try data.write(to: fileURL, options: .atomic)
            #endif
            print("StoryStorage: Saved \(savedStories.count) stories to \(fileURL.path)")
        } catch {
            print("Failed to save stories: \(error)")
        }
    }
    
    /// Loads saved stories from persistent storage
    /// - Returns: Array of saved stories, empty array if none exist
    static func load() -> [SavedStory] {
        do {
            let data = try Data(contentsOf: fileURL)
            let stories = try JSONDecoder().decode([SavedStory].self, from: data)
            print("StoryStorage: Loaded \(stories.count) stories from \(fileURL.path)")
            return stories
        } catch {
            print("Failed to load saved stories: \(error)")
            return []
        }
    }
} 

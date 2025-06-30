import Foundation

class AppStorageManager {
    static let shared = AppStorageManager()
    private let voiceIDKey = "lastSelectedVoiceID"
    private let emotionKey = "lastSelectedEmotion"
    private let languageKey = "lastSelectedLanguage"
    private let channelKey = "lastSelectedChannel"
    private init() {}

    func saveVoiceSelection(voiceID: String, emotion: String, language: String, channel: String) {
        let defaults = UserDefaults.standard
        defaults.set(voiceID, forKey: voiceIDKey)
        defaults.set(emotion, forKey: emotionKey)
        defaults.set(language, forKey: languageKey)
        defaults.set(channel, forKey: channelKey)
    }

    func loadVoiceSelection() -> (voiceID: String?, emotion: String?, language: String?, channel: String?) {
        let defaults = UserDefaults.standard
        let voiceID = defaults.string(forKey: voiceIDKey)
        let emotion = defaults.string(forKey: emotionKey)
        let language = defaults.string(forKey: languageKey)
        let channel = defaults.string(forKey: channelKey)
        return (voiceID, emotion, language, channel)
    }
} 
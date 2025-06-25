import Foundation

class AppStorageManager {
    static let shared = AppStorageManager()
    private let voiceIDKey = "lastSelectedVoiceID"
    private let emotionKey = "lastSelectedEmotion"
    private let languageKey = "lastSelectedLanguage"
    private let channelKey = "lastSelectedChannel"
    private let onboardingCompletedKey = "onboardingCompleted"
    private let primaryUseCaseKey = "primaryUseCase"
    private let preferredVoiceTypeKey = "preferredVoiceType"
    private let languagePreferencesKey = "languagePreferences"
    private let contentInterestsKey = "contentInterests"
    private let usageFrequencyKey = "usageFrequency"
    private let voiceEmotionPreferenceKey = "voiceEmotionPreference"
    private let deviceUsageKey = "deviceUsage"
    private let notificationPreferenceKey = "notificationPreference"
    
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
    
    // MARK: - Onboarding Methods
    
    func isOnboardingCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: onboardingCompletedKey)
    }
    
    func markOnboardingCompleted() {
        UserDefaults.standard.set(true, forKey: onboardingCompletedKey)
    }
    
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: onboardingCompletedKey)
        UserDefaults.standard.removeObject(forKey: primaryUseCaseKey)
        UserDefaults.standard.removeObject(forKey: preferredVoiceTypeKey)
        UserDefaults.standard.removeObject(forKey: languagePreferencesKey)
        UserDefaults.standard.removeObject(forKey: contentInterestsKey)
        UserDefaults.standard.removeObject(forKey: usageFrequencyKey)
        UserDefaults.standard.removeObject(forKey: voiceEmotionPreferenceKey)
        UserDefaults.standard.removeObject(forKey: deviceUsageKey)
        UserDefaults.standard.removeObject(forKey: notificationPreferenceKey)
    }
    
    func saveOnboardingPreferences(
        primaryUseCase: String,
        preferredVoiceType: String,
        languagePreferences: [String],
        contentInterests: [String],
        usageFrequency: String,
        voiceEmotionPreference: String,
        deviceUsage: String,
        notificationPreference: String
    ) {
        let defaults = UserDefaults.standard
        defaults.set(primaryUseCase, forKey: primaryUseCaseKey)
        defaults.set(preferredVoiceType, forKey: preferredVoiceTypeKey)
        defaults.set(languagePreferences, forKey: languagePreferencesKey)
        defaults.set(contentInterests, forKey: contentInterestsKey)
        defaults.set(usageFrequency, forKey: usageFrequencyKey)
        defaults.set(voiceEmotionPreference, forKey: voiceEmotionPreferenceKey)
        defaults.set(deviceUsage, forKey: deviceUsageKey)
        defaults.set(notificationPreference, forKey: notificationPreferenceKey)
    }
    
    func getOnboardingPreferences() -> (
        primaryUseCase: String?,
        preferredVoiceType: String?,
        languagePreferences: [String]?,
        contentInterests: [String]?,
        usageFrequency: String?,
        voiceEmotionPreference: String?,
        deviceUsage: String?,
        notificationPreference: String?
    ) {
        let defaults = UserDefaults.standard
        return (
            defaults.string(forKey: primaryUseCaseKey),
            defaults.string(forKey: preferredVoiceTypeKey),
            defaults.stringArray(forKey: languagePreferencesKey),
            defaults.stringArray(forKey: contentInterestsKey),
            defaults.string(forKey: usageFrequencyKey),
            defaults.string(forKey: voiceEmotionPreferenceKey),
            defaults.string(forKey: deviceUsageKey),
            defaults.string(forKey: notificationPreferenceKey)
        )
    }
} 
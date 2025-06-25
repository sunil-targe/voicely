import Foundation
import SwiftUI
import Amplitude

class OnboardingViewModel: ObservableObject {
    static let shared = OnboardingViewModel()
    
    private init() {}
    
    // MARK: - Apply User Preferences
    
    func applyUserPreferences() {
        let preferences = AppStorageManager.shared.getOnboardingPreferences()
        
        // Apply voice type preference
        if let preferredVoiceType = preferences.preferredVoiceType {
            applyVoiceTypePreference(preferredVoiceType)
        }
        
        // Apply language preferences
        if let languagePreferences = preferences.languagePreferences {
            applyLanguagePreferences(languagePreferences)
        }
        
        // Apply content interests
        if let contentInterests = preferences.contentInterests {
            applyContentInterests(contentInterests)
        }
        
        // Apply emotion preference
        if let emotionPreference = preferences.voiceEmotionPreference {
            applyEmotionPreference(emotionPreference)
        }
    }
    
    private func applyVoiceTypePreference(_ preference: String) {
        // Set default voice based on preference
        let voices = Voice.all
        var defaultVoice: Voice?
        
        switch preference {
        case "Female voices":
            defaultVoice = voices.first { voice in
                voice.name.contains("Woman") || voice.name.contains("Girl") || voice.name.contains("Manner") || voice.name.contains("Abbess")
            }
        case "Male voices":
            defaultVoice = voices.first { voice in
                voice.name.contains("Man") || voice.name.contains("Boy") || voice.name.contains("Person") || voice.name.contains("Guy")
            }
        default:
            defaultVoice = Voice.default
        }
        
        if let voice = defaultVoice {
            AppStorageManager.shared.saveVoiceSelection(
                voiceID: voice.voice_id,
                emotion: voice.emotion,
                language: voice.language,
                channel: voice.channel
            )
        }
    }
    
    private func applyLanguagePreferences(_ languages: [String]) { //TODO: setup language preferece
        // Set default language based on preferences
        if languages.contains("English") {
            // English is default, no change needed
        } else if languages.contains("Hindi") {
            // Set Hindi as default language
            // This would be implemented based on your language switching logic
        }
        // Add more language logic as needed
    }
    
    private func applyContentInterests(_ interests: [String]) {
        // Store content interests for future use
        // This could be used to show relevant content in the app
        UserDefaults.standard.set(interests, forKey: "userContentInterests")
    }
    
    private func applyEmotionPreference(_ emotion: String) {
        // Map emotion preference to voice emotion setting
        let emotionMapping: [String: String] = [
            "Calm and soothing": "calm",
            "Energetic and lively": "energetic",
            "Professional and formal": "formal",
            "Friendly and casual": "casual",
            "Inspirational and motivational": "inspirational"
        ]
        
        if let mappedEmotion = emotionMapping[emotion] {
            // Update the default emotion setting
            UserDefaults.standard.set(mappedEmotion, forKey: "defaultEmotion")
        }
    }
    
    // MARK: - Get Personalized Suggestions
    
    func getPersonalizedVoiceSuggestions() -> [Voice] {
        let preferences = AppStorageManager.shared.getOnboardingPreferences()
        let voices = Voice.all
        
        guard let preferredVoiceType = preferences.preferredVoiceType else {
            return Array(voices.prefix(3))
        }
        
        switch preferredVoiceType {
        case "Female voices":
            return voices.filter { voice in
                voice.name.contains("Woman") || voice.name.contains("Girl") || voice.name.contains("Person")
            }
        case "Male voices":
            return voices.filter { voice in
                voice.name.contains("Man") || voice.name.contains("Boy") || voice.name.contains("Knight")
            }
        default:
            return Array(voices.prefix(3))
        }
    }
    
    func getPersonalizedContentSuggestions() -> [String] {
        let preferences = AppStorageManager.shared.getOnboardingPreferences()
        
        guard let contentInterests = preferences.contentInterests else {
            return Array(Constants.stories.prefix(3))
        }
        
        var suggestions: [String] = []
        
        if contentInterests.contains("Bedtime stories") {
            suggestions.append(contentsOf: Array(Constants.nightStories["English"]?.prefix(2) ?? []))
        }
        
        if contentInterests.contains("Jokes and humor") {
            suggestions.append(contentsOf: Array(Constants.jokes.prefix(2)))
        }
        
        if contentInterests.contains("Birthday wishes") {
            // Add birthday wishes suggestions
            suggestions.append("Happy Birthday! May your day be filled with joy and laughter.")
        }
        
        return suggestions.isEmpty ? Array(Constants.stories.prefix(3)) : suggestions
    }
    
    // MARK: - Usage Analytics
    
    func trackOnboardingCompletion() {
        let preferences = AppStorageManager.shared.getOnboardingPreferences()
        
        // Track onboarding completion with Amplitude
        Amplitude.instance().logEvent("onboarding_completed", withEventProperties: [
            "primary_use_case": preferences.primaryUseCase ?? "unknown",
            "preferred_voice_type": preferences.preferredVoiceType ?? "unknown",
            "selected_languages": preferences.languagePreferences?.joined(separator: ", ") ?? "unknown",
            "content_interests": preferences.contentInterests?.joined(separator: ", ") ?? "unknown",
            "usage_frequency": preferences.usageFrequency ?? "unknown",
            "voice_emotion_preference": preferences.voiceEmotionPreference ?? "unknown",
            "device_usage": preferences.deviceUsage ?? "unknown",
            "notification_preference": preferences.notificationPreference ?? "unknown"
        ])
    }
    
    func trackPaywallShown(source: String) {
        Amplitude.instance().logEvent("paywall_shown", withEventProperties: [
            "source": source,
            "is_onboarding_completed": AppStorageManager.shared.isOnboardingCompleted()
        ])
    }
} 

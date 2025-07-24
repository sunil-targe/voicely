import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @State private var primaryUseCase = ""
    @State private var preferredVoiceType = ""
    @State private var selectedLanguages: Set<String> = []
    @State private var selectedContentInterests: Set<String> = []
    @State private var usageFrequency = ""
    @State private var voiceEmotionPreference = ""
    @State private var deviceUsage = ""
    @State private var notificationPreference = ""
    @State private var showMainApp = false
    
    private let totalSteps = 8 // Total steps including welcome (0) + 7 questions (Make it 8 if required PN step)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress bar and step indicator (only show for non-welcome steps)
                if currentStep > 0 {
                    // Progress bar
                    ProgressView(value: Double(currentStep), total: Double(totalSteps - 1))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.98, green: 0.67, blue: 0.53)))
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Step indicator
                    HStack {
                        Text("Step \(currentStep) of \(totalSteps - 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                // Content
                if currentStep == 0 {
                    welcomeStep
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Question content
                            questionContent
                                .padding(.top, currentStep == 0 ? 0 : 40)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            playHapticFeedback()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }
                        .foregroundColor(Color(red: 0.98, green: 0.67, blue: 0.53))
                    }
                    
                    Spacer()
                    
                    // Skip button (only show on first question step)
                    if currentStep == 1 {
                        Button("Skip") {
                            playHapticFeedback()
                            skipOnboarding()
                        }
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.trailing, 16)
                    }
                    
                    Button(currentStep == 0 ? "Get Started" : (currentStep == totalSteps - 1 ? "Complete" : "Next")) {
                        playHapticFeedback()
                        if currentStep == totalSteps - 1 {
                            completeOnboarding()
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(canProceed ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color.gray)
                    .cornerRadius(25)
                    .disabled(!canProceed)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(Color(.systemBackground))
        }
        .fullScreenCover(isPresented: $showMainApp) {
            ContentView()
                .environmentObject(PurchaseViewModel.shared)
        }
    }
    
    @ViewBuilder
    private var questionContent: some View {
        switch currentStep {
        case 1:
            primaryUseCaseStep
        case 2:
            preferredVoiceTypeStep
        case 3:
            languagePreferencesStep
        case 4:
            contentInterestsStep
        case 5:
            usageFrequencyStep
        case 6:
            voiceEmotionPreferenceStep
        case 7:
            deviceUsageStep
        case 8:
            notificationPreferenceStep
        default:
            EmptyView()
        }
    }
    
    private var welcomeStep: some View {
        // Welcome message for first step
        VStack(spacing: 20) {
            Spacer()
            Image("voicely_icon")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            
            Text("Welcome to Voicely 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Let's personalize your experience with a few quick questions.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
    }
    
    private var primaryUseCaseStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What will you mainly use Voicely for?")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(primaryUseCases, id: \.self) { useCase in
                    Button(action: {
                        playHapticFeedback()
                        primaryUseCase = useCase
                    }) {
                        HStack {
                            Text(useCase)
                                .foregroundColor(primaryUseCase == useCase ? .white : .primary)
                            Spacer()
                            if primaryUseCase == useCase {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(primaryUseCase == useCase ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var preferredVoiceTypeStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What type of voice do you prefer?")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(voiceTypes, id: \.self) { voiceType in
                    Button(action: {
                        playHapticFeedback()
                        preferredVoiceType = voiceType
                    }) {
                        HStack {
                            Text(voiceType)
                                .foregroundColor(preferredVoiceType == voiceType ? .white : .primary)
                            Spacer()
                            if preferredVoiceType == voiceType {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(preferredVoiceType == voiceType ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var languagePreferencesStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Which languages are you interested in?")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Select all that apply")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                ForEach(languages, id: \.self) { language in
                    Button(action: {
                        playHapticFeedback()
                        if selectedLanguages.contains(language) {
                            selectedLanguages.remove(language)
                        } else {
                            selectedLanguages.insert(language)
                        }
                    }) {
                        HStack {
                            Text(language)
                                .foregroundColor(selectedLanguages.contains(language) ? .white : .primary)
                            Spacer()
                            if selectedLanguages.contains(language) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(selectedLanguages.contains(language) ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var contentInterestsStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What content interests you most?")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Select all that apply")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                ForEach(contentTypes, id: \.self) { contentType in
                    Button(action: {
                        playHapticFeedback()
                        if selectedContentInterests.contains(contentType) {
                            selectedContentInterests.remove(contentType)
                        } else {
                            selectedContentInterests.insert(contentType)
                        }
                    }) {
                        HStack {
                            Text(contentType)
                                .foregroundColor(selectedContentInterests.contains(contentType) ? .white : .primary)
                            Spacer()
                            if selectedContentInterests.contains(contentType) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(selectedContentInterests.contains(contentType) ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var usageFrequencyStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("How often do you plan to use Voicely?")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(usageFrequencies, id: \.self) { frequency in
                    Button(action: {
                        playHapticFeedback()
                        usageFrequency = frequency
                    }) {
                        HStack {
                            Text(frequency)
                                .foregroundColor(usageFrequency == frequency ? .white : .primary)
                            Spacer()
                            if usageFrequency == frequency {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(usageFrequency == frequency ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var voiceEmotionPreferenceStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What emotion do you prefer in voices?")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(voiceEmotions, id: \.self) { emotion in
                    Button(action: {
                        playHapticFeedback()
                        voiceEmotionPreference = emotion
                    }) {
                        HStack {
                            Text(emotion)
                                .foregroundColor(voiceEmotionPreference == emotion ? .white : .primary)
                            Spacer()
                            if voiceEmotionPreference == emotion {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(voiceEmotionPreference == emotion ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var deviceUsageStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Where will you mostly use Voicely?")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(deviceUsageOptions, id: \.self) { option in
                    Button(action: {
                        playHapticFeedback()
                        deviceUsage = option
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(deviceUsage == option ? .white : .primary)
                            Spacer()
                            if deviceUsage == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(deviceUsage == option ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var notificationPreferenceStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Would you like to receive notifications about new features?")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(notificationOptions, id: \.self) { option in
                    Button(action: {
                        playHapticFeedback()
                        notificationPreference = option
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(notificationPreference == option ? .white : .primary)
                            Spacer()
                            if notificationPreference == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(notificationPreference == option ? Color(red: 0.98, green: 0.67, blue: 0.53) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return true
        case 1:
            return !primaryUseCase.isEmpty
        case 2:
            return !preferredVoiceType.isEmpty
        case 3:
            return !selectedLanguages.isEmpty
        case 4:
            return !selectedContentInterests.isEmpty
        case 5:
            return !usageFrequency.isEmpty
        case 6:
            return !voiceEmotionPreference.isEmpty
        case 7:
            return !deviceUsage.isEmpty
        case 8:
            return !notificationPreference.isEmpty
        default:
            return false
        }
    }
    
    private func completeOnboarding() {
        AppStorageManager.shared.saveOnboardingPreferences(
            primaryUseCase: primaryUseCase,
            preferredVoiceType: preferredVoiceType,
            languagePreferences: Array(selectedLanguages),
            contentInterests: Array(selectedContentInterests),
            usageFrequency: usageFrequency,
            voiceEmotionPreference: voiceEmotionPreference,
            deviceUsage: deviceUsage,
            notificationPreference: notificationPreference
        )
        AppStorageManager.shared.markOnboardingCompleted()
        
        // Apply user preferences
        OnboardingViewModel.shared.applyUserPreferences()
        
        // Track onboarding completion
        OnboardingViewModel.shared.trackOnboardingCompletion()
        
        // Show main app after onboarding completion
        showMainApp = true
    }
    
    private func skipOnboarding() {
        AppStorageManager.shared.markOnboardingCompleted()
        
        // Show main app after skipping onboarding
        showMainApp = true
    }
    
    // MARK: - Data Arrays
    
    private let primaryUseCases = [
        "Reading stories to children",
        "Creating content for social media",
        "Learning/practicing languages",
        "Professional presentations",
        "Personal entertainment",
        "Other"
    ]
    
    private let voiceTypes = [
        "Female voices",
        "Male voices",
        "No preference"
    ]
    
    private let languages = [
        "English",
        "Hindi",
        "Chinese",
        "Spanish",
        "French",
        "German",
        "Other"
    ]
    
    private let contentTypes = [
        "Bedtime stories",
        "Birthday wishes",
        "Jokes and humor",
        "Educational content",
        "Professional content",
        "Personal messages"
    ]
    
    private let usageFrequencies = [
        "Daily",
        "Weekly",
        "Monthly",
        "Occasionally"
    ]
    
    private let voiceEmotions = [
        "Calm and soothing",
        "Energetic and lively",
        "Professional and formal",
        "Friendly and casual",
        "Inspirational and motivational"
    ]
    
    private let deviceUsageOptions = [
        "At home",
        "During commute",
        "At work",
        "While traveling",
        "Multiple locations"
    ]
    
    private let notificationOptions = [
        "Yes, keep me updated",
        "No, thanks",
        "Only important updates"
    ]
}

#Preview {
    OnboardingView()
} 

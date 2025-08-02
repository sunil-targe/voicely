import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @State private var selectedUsage: UsageOption = .bedtimeStories
    @State private var selectedStorytime: StorytimeOption = .bedtime
    @State private var selectedFrequency: FrequencyOption = .everyDay
    @State private var showMainApp = false
    
    private let totalSteps = 4

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if currentStep > 0 {
                    ProgressView(value: Double(currentStep), total: Double(totalSteps - 1))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.indigo))
                        .padding(.horizontal)
                        .padding(.top)

                    HStack {
                        Text("Step \(currentStep) of \(totalSteps - 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                }

                if currentStep == 0 {
                    welcomeStep
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            questionContent
                                .padding(.top, currentStep == 0 ? 0 : 40)

                            Spacer(minLength: 100)
                        }
                    }
                }

                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            playHapticFeedback()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }
                        .foregroundColor(Color.indigo)
                    }

                    Spacer()

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
                    .background(canProceed ? Color.indigo : Color.gray)
                    .cornerRadius(25)
                    .disabled(!canProceed)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(Color(.secondarySystemBackground))
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
            UsageSelectionView(selectedOption: $selectedUsage)
                .environment(\.hideProgressBar, true)
        case 2:
            StorytimeSelectionView(selectedTime: $selectedStorytime)
                .environment(\.hideProgressBar, true)
        case 3:
            UsageFrequencyView(selectedOption: $selectedFrequency)
                .environment(\.hideProgressBar, true)
        default:
            EmptyView()
        }
    }

    private var welcomeStep: some View {
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

    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return true
        case 1:
            return true // UsageOption has a default value
        case 2:
            return true // StorytimeOption has a default value
        case 3:
            return true // FrequencyOption has a default value
        case 4:
            return true // VoiceOption has a default value
        default:
            return false
        }
    }

    private func completeOnboarding() {
        AppStorageManager.shared.markOnboardingCompleted()
        showMainApp = true
    }

    private func skipOnboarding() {
        showMainApp = true
    }

    private func playHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

// Environment key to hide progress bars in subviews
private struct HideProgressBarKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var hideProgressBar: Bool {
        get { self[HideProgressBarKey.self] }
        set { self[HideProgressBarKey.self] = newValue }
    }
}

// Preview with step navigation for testing
struct NewOnbordingViewPreview: View {
    @State private var currentStep = 0
    
    var body: some View {
        VStack {
            Text("Onboarding Preview - Step \(currentStep)")
                .font(.headline)
                .padding()
            
            HStack {
                Button("Step 0") { currentStep = 0 }
                Button("Step 1") { currentStep = 1 }
                Button("Step 2") { currentStep = 2 }
                Button("Step 3") { currentStep = 3 }
                Button("Step 4") { currentStep = 4 }
            }
            .padding()
            
            OnboardingView()
        }
    }
}

#Preview {
    OnboardingView()
}

#Preview("All Steps") {
    NewOnbordingViewPreview()
}

#Preview("Step 1 - Usage") {
    UsageSelectionView(selectedOption: .constant(.bedtimeStories))
        .environment(\.hideProgressBar, true)
}

#Preview("Step 2 - Storytime") {
    StorytimeSelectionView(selectedTime: .constant(.bedtime))
        .environment(\.hideProgressBar, true)
}

#Preview("Step 3 - Frequency") {
    UsageFrequencyView(selectedOption: .constant(.everyDay))
        .environment(\.hideProgressBar, true)
}



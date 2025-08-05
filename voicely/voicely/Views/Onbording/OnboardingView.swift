import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @State private var selectedUsage: UsageOption?
    @State private var selectedStorytime: StorytimeOption?
    @State private var selectedFrequency: FrequencyOption?
    @State private var showMainApp = false
    @State private var progressValue: Double = 0.0
    @State private var showThankYou = false
    @State private var isRotated = false
    
    private let totalSteps = 5 // Updated to include loading step

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                if currentStep == 0 {
                    welcomeStep
                } else if currentStep == totalSteps - 1 {
                    loadingStep
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            questionContent
                                .padding(.top, currentStep == 0 ? 0 : 40)

                            Spacer()
                        }
                    }
                }

                // Navigation buttons - show for all steps except loading step
                if currentStep < totalSteps - 1 {
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

                        // Show Skip button for all steps except the last one
                        if currentStep > 0 && currentStep < totalSteps - 1 {
                            Button("Skip") {
                                playHapticFeedback()
                                skipToNextStep()
                            }
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.trailing, 16)
                        }

                        Button(currentStep == 0 ? "Get Started" : currentStep == totalSteps - 2 ? "Complete" : "Next") {
                            playHapticFeedback()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
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
        case 2:
            StorytimeSelectionView(selectedTime: $selectedStorytime)
        case 3:
            UsageFrequencyView(selectedOption: $selectedFrequency)
        default:
            EmptyView()
        }
    }

    private var welcomeStep: some View {
        VStack(spacing: 40) {
            Spacer()
            VStack(spacing: 10) {
                Image("voicely_icon")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(40)
                
                Text("Voicely")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            .rotationEffect(.degrees(isRotated ? -10 : 0))
            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: isRotated)
            .onAppear {
                isRotated = true
            }
            
            
            VStack(spacing: 10) {
                Text("Storytime with your voice")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text("Create magical bedtime stories, narrated in the comfort of your own voice. A cherished bond. A timeless memory.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
        }
    }
    
    private var loadingStep: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Title with animation
            VStack(spacing: 16) {
                Text(showThankYou ? "Thank you! 🎉" : "Working on it...")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut(duration: 0.5), value: showThankYou)
                
                // Simplified progress bar
                VStack(spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .cornerRadius(4)
                            
                            // Progress fill
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.indigo, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(4)
                                .frame(width: geometry.size.width * progressValue)
                        }
                    }
                    .frame(height: 8)
                    .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            startLoadingAnimation()
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return true
        case 1:
            return selectedUsage != nil
        case 2:
            return selectedStorytime != nil
        case 3:
            return selectedFrequency != nil
        default:
            return false
        }
    }

    private func completeOnboarding() {
        // Save the selected options to UserDefaults or your data store
        saveOnboardingSelections()
        AppStorageManager.shared.markOnboardingCompleted()
        showMainApp = true
    }

    private func skipToNextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep += 1
        }
    }
    
    private func startLoadingAnimation() {
        // Reset progress value to ensure animation starts from 0
        progressValue = 0.0
        
        // Animate progress bar over 3 seconds
        withAnimation(.linear(duration: 3.0)) {
            progressValue = 1.0
        }
        
        // After 3 seconds, show "Thank you" and then complete onboarding
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showThankYou = true
            }
            
            // Complete onboarding after showing "Thank you"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completeOnboarding()
            }
        }
    }

    private func saveOnboardingSelections() {
        // Save the selected options to persistent storage
        if let usage = selectedUsage {
            UserDefaults.standard.set(usage.rawValue, forKey: "onboarding_usage")
        }
        if let storytime = selectedStorytime {
            UserDefaults.standard.set(storytime.rawValue, forKey: "onboarding_storytime")
        }
        if let frequency = selectedFrequency {
            UserDefaults.standard.set(frequency.rawValue, forKey: "onboarding_frequency")
        }
    }

    private func playHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
}

#Preview {
    OnboardingView()
}

import SwiftUI
import AVFoundation

struct VoiceCloneView: View {
    @StateObject private var viewModel = CloneVoiceViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingNameInput = false
    @State private var currentStep = 0 // 0: intro, 1: recording, 2: preview, 3: naming, 4: cloning
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient similar to the reference
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.3, green: 0.4, blue: 0.9),
                        Color(red: 0.5, green: 0.6, blue: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // Progress indicator
                    ProgressStepView(currentStep: currentStep, totalSteps: 4)
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Main content based on current step
                    Group {
                        switch currentStep {
                        case 0:
                            IntroStepView(onContinue: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentStep = 1
                                }
                            })
                        case 1:
                            RecordingStepView(viewModel: viewModel, onContinue: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentStep = 2
                                }
                            })
                        case 2:
                            PreviewStepView(viewModel: viewModel, onContinue: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentStep = 3
                                }
                            }, onRetry: {
                                viewModel.resetRecording()
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentStep = 1
                                }
                            })
                        case 3:
                            NamingStepView(viewModel: viewModel, onContinue: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentStep = 4
                                }
                                viewModel.startVoiceCloning()
                            })
                        case 4:
                            CloningStepView(viewModel: viewModel, onComplete: {
                                dismiss()
                            })
                        default:
                            EmptyView()
                        }
                    }
//                    .transition(.opacity.combined(with: .move(edge: .leading)))
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        playHapticFeedback()
                        viewModel.resetRecording()
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .alert("Permission Required", isPresented: $viewModel.showPermissionDenied) {
            Button("Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Microphone access is required to clone your voice. Please enable it in Settings.")
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// MARK: - Progress Step View
struct ProgressStepView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Rectangle()
                    .fill(step <= currentStep ? Color.white : Color.white.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                if step < totalSteps - 1 {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 8, height: 4)
                }
            }
        }
    }
}

// MARK: - Intro Step View
struct IntroStepView: View {
    let onContinue: () -> Void
    @State private var quietPlaceChecked = false
    @State private var speakNaturalChecked = false
    @State private var useMicrophoneChecked = false
    
    var allChecked: Bool {
        quietPlaceChecked && speakNaturalChecked && useMicrophoneChecked
    }
    
    var body: some View {
        VStack {
            ScrollView {
                // Illustration
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                    // Microphone icon
                    Image(systemName: "person.wave.2.fill")
                        .font(.system(size: 64, weight: .thin))
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                
                // Title
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Let's Get Ready")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        // Subheader
                        Text("Follow the instructions below to record your voice. Ensure a quiet environment for the best quality.")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.bottom)
                .padding(.horizontal, 36)

                
                // Instructions with checkboxes
                VStack(spacing: 16) {
                    CheckableInstructionRow(
                        text: "Find a quiet place",
                        isChecked: $quietPlaceChecked
                    )
                    
                    CheckableInstructionRow(
                        text: "Speak clearly and naturally",
                        isChecked: $speakNaturalChecked
                    )
                    
                    CheckableInstructionRow(
                        text: "Avoid background noise",
                        isChecked: $useMicrophoneChecked
                    )
                }
                .padding(.vertical)
                .padding(.horizontal, 36)
                Spacer()
            }
            
            // Continue button
            Button(action: {
                playHapticFeedback()
                onContinue()
            }) {
                Text("Record voice")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(allChecked ? .white : .white.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(allChecked ? Color(red: 0.2, green: 0.3, blue: 0.8) : Color(red: 0.2, green: 0.3, blue: 0.8).opacity(0.3))
                    .cornerRadius(16)
            }
            .disabled(!allChecked)
            .padding(.horizontal, 36)
        }
    }
}

struct CheckableInstructionRow: View {
    let text: String
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            playHapticFeedback()
            isChecked.toggle()
        }) {
            HStack(alignment: .center, spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Text
                Text(text)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InstructionRow: View {
    let text: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).imageScale(.medium)
                .foregroundColor(.white.opacity(0.8))
                .offset(y: 3)
            
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

// MARK: - Recording Step View
struct RecordingStepView: View {
    @ObservedObject var viewModel: CloneVoiceViewModel
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // Script display
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(viewModel.cloneScript.enumerated()), id: \.offset) { index, text in
                        ZStack {
                            HStack {
                                Text(text)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(index == viewModel.currentScriptIndex ? .white : .white.opacity(0.6))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                Spacer()
                            }
                        }
                        .background(
                            index == viewModel.currentScriptIndex ?
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color.white.opacity(0.2))
                            : nil
                        )
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentScriptIndex)
                    }
                }
                .padding(.vertical, 30)
            }
            
            Spacer()
            
            // Recording controls
            VStack(spacing: 20) {
                if viewModel.isRecording {
                    Text(viewModel.formattedRecordingTime)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // Record button
                Button(action: {
                    playHapticFeedback()
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .fill(viewModel.isRecording ? Color.red : Color.white)
                            .frame(width: viewModel.isRecording ? 60 : 80, height: viewModel.isRecording ? 60 : 80)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.isRecording)
                        
                        if !viewModel.isRecording {
                            Image(systemName: "mic.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.8))
                        }
                    }
                }
                
                if viewModel.hasRecordedAudio {
                    Button(action: {
                        playHapticFeedback()
                        validateAndContinue()
                    }) {
                        HStack {
                            Text("Continue")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.2, green: 0.3, blue: 0.8))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .alert("Recording Validation", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private func validateAndContinue() {
        let recordingDuration = viewModel.recordingTime
        
        if recordingDuration < 10 {
            validationMessage = "Recording is too short. Please record at least 10 seconds of audio."
            showValidationAlert = true
        } else if recordingDuration > 120 { // 2 minutes = 120 seconds
            validationMessage = "Recording is too long. Please record between 10 seconds and 2 minutes."
            showValidationAlert = true
        } else {
            onContinue()
        }
    }
}

// MARK: - Preview Step View
struct PreviewStepView: View {
    @ObservedObject var viewModel: CloneVoiceViewModel
    let onContinue: () -> Void
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            // Success icon and title
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("Recording Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Preview controls
            VStack(spacing: 16) {
                Text("Listen to your recording:")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                
                Button(action: {
                    playHapticFeedback()
                    viewModel.playRecordedAudio()
                }) {
                    HStack {
                        Image(systemName: viewModel.isPlayingRecording ? "stop.fill" : "play.fill")
                        Text(viewModel.isPlayingRecording ? "Playing" : "Play Recording")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    playHapticFeedback()
                    viewModel.stopPlayback()
                    onContinue()
                }) {
                    Text("Sounds Good!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.2, green: 0.3, blue: 0.8))
                        .cornerRadius(16)
                }
                
                Button(action: {
                    playHapticFeedback()
                    onRetry()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Record Again")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Naming Step View
struct NamingStepView: View {
    @ObservedObject var viewModel: CloneVoiceViewModel
    @FocusState private var isTextFieldFocused: Bool
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            // Title
            Text("Name Your Voice")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Input field
            VStack(alignment: .leading, spacing: 8) {
                Text("Voice Name")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                
                TextField("Enter a name for your voice", text: $viewModel.clonedVoiceName)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal, 12)
                    .frame(height: 54)
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .font(.title2)
                    .tint(.white)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Continue button
            Button(action: {
                playHapticFeedback()
                onContinue()
            }) {
                Text("Clone Voice")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.canStartCloning ? .white : .white.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.2, green: 0.3, blue: 0.8))
                    .cornerRadius(16)
            }
            .disabled(!viewModel.canStartCloning)
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 30)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

// MARK: - Cloning Step View
struct CloningStepView: View {
    @ObservedObject var viewModel: CloneVoiceViewModel
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            if viewModel.cloneSuccess {
                // Success state
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("Voice Cloned!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Your voice has been successfully cloned and is ready to use.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                Button(action: {
                    playHapticFeedback()
                    onComplete()
                }) {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.2, green: 0.3, blue: 0.8))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 40)
                
            } else {
                // Loading state
                VStack(spacing: 30) {
                    // Animated cloning indicator
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.white, lineWidth: 8)
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                            .rotationEffect(.degrees(viewModel.isCloning ? 360 : 0))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.isCloning)
                        
                        Image(systemName: "waveform")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    
                    Text("Cloning your voice...")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(viewModel.cloneProgress)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 30)
        .onAppear {
            if viewModel.isCloning {
                // Start the rotation animation
                viewModel.objectWillChange.send()
            }
        }
    }
}

#if DEBUG
#Preview {
    VoiceCloneView()
}
#endif

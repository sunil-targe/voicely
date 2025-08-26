import SwiftUI
import AVFoundation
import RevenueCat
import RevenueCatUI

class VoiceNameViewModel: ObservableObject {
    @Published var voices: [Voice] = Voice.all
    @Published var selectedVoice: Voice?
    @Published var showSelectButton: Bool = false
    @Published var currentlyPlayingVoiceID: String? = nil
    @Published var showFilters: Bool = false
    @Published var globalEmotion: String = "auto"
    @Published var globalLanguage: String = "Automatic"
    @Published var globalChannel: String = "mono"
    @Published var showPaywall: Bool = false
    @Published var showVoiceClone: Bool = false
    @Published var clonedVoices: [ClonedVoice] = []
    private var audioPlayer: AVAudioPlayer?
    let purchaseVM = PurchaseViewModel.shared
    private let clonedVoiceStorage = ClonedVoiceStorage.shared

    init() {
        selectedVoice = voices.first
        loadClonedVoices()
    }
    
    func selectVoice(_ voice: Voice) {
        // Check if voice is free (first two voices are free)
        if isVoiceFree(voice) {
            selectedVoice = voice
            showSelectButton = true
        } else {
            // Show paywall for premium voices
            showPaywall = true
        }
    }
    
    func isVoiceFree(_ voice: Voice) -> Bool {
        // If user is premium, all voices are free
        if purchaseVM.isPremium {
            return true
        }
        
        // Only "Grandma Willow" and "Thunder Bear" are free for non-premium users
        return ["Wise_Woman", "Deep_Voice_Man"].contains(voice.voice_id)
    }
    
    func playPreview(for voice: Voice) {
        stopPreview()
        
        // Configure audio session for preview playback
        AudioSessionManager.shared.configureAudioSession()
        
        guard let url = Bundle.main.url(forResource: voice.voice_id, withExtension: "mp3") else {
            print("Preview audio not found for \(voice.voice_id)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            currentlyPlayingVoiceID = voice.voice_id
        } catch {
            print("Failed to play preview: \(error)")
        }
    }
    
    func stopPreview() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentlyPlayingVoiceID = nil
    }
    
    func loadClonedVoices() {
        clonedVoices = clonedVoiceStorage.clonedVoices
    }
    
    func deleteClonedVoice(_ clonedVoice: ClonedVoice) {
        clonedVoiceStorage.deleteClonedVoice(clonedVoice)
        loadClonedVoices()
    }
    
    func playClonedVoicePreview(for clonedVoice: ClonedVoice) {
        stopPreview()
        
        // Configure audio session for preview playback
        AudioSessionManager.shared.configureAudioSession()
        
        do {
            audioPlayer = try AVAudioPlayer(data: clonedVoice.audioData)
            audioPlayer?.play()
            currentlyPlayingVoiceID = clonedVoice.voiceID
        } catch {
            print("Failed to play cloned voice preview: \(error)")
        }
    }
}

struct VoiceNameScreen: View {
    @Binding var isPresented: Bool
    @Binding var selectedVoice: Voice
    @StateObject private var viewModel = VoiceNameViewModel()
    @State private var tempSelectedVoice: Voice?
    @State private var showVoiceSettingsGuidelines = false

    private let emotions = [
        ("auto", "🎭"),
        ("neutral", "😐"),
        ("happy", "😊"),
        ("sad", "😢"),
        ("angry", "😠"),
        ("fearful", "😨"),
        ("disgusted", "🤢"),
        ("surprised", "😲")
    ]
    private let languages = [
        "None", "Automatic", "Chinese", "Chinese,Yue", "English", "Hindi", "Arabic", "Russian", "Spanish", "French", "Portuguese", "German", "Turkish", "Dutch", "Ukrainian", "Vietnamese", "Indonesian", "Japanese", "Italian", "Korean", "Thai", "Polish", "Romanian", "Greek", "Czech", "Finnish"
    ]
    private let channels = ["mono", "stereo"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 6) {
                // Filter Section
                if viewModel.showFilters {
                    VStack(spacing: 16) {
                        // Filter Header
                        HStack {
                            Button(action: {
                                playHapticFeedback()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showVoiceSettingsGuidelines = true
                                }
                            }) {
                                HStack(alignment: .center, spacing: 6) {
                                    Text("Voice settings")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Image("ic_info")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Button(action: {
                                playHapticFeedback()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    viewModel.showFilters = false
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title3)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 15)
                        
                        // Filter Action Buttons
                        HStack(spacing: 12) {
                            // Emotion Filter
                            FilterActionButton(
                                title: "Emotion",
                                value: getEmotionDisplayValue(viewModel.globalEmotion),
                                options: emotions.map { "\($0.1) \($0.0.capitalized)" },
                                onSelect: { selected in
                                    let emotion = selected.replacingOccurrences(of: "🎭 ", with: "")
                                        .replacingOccurrences(of: "😐 ", with: "")
                                        .replacingOccurrences(of: "😊 ", with: "")
                                        .replacingOccurrences(of: "😢 ", with: "")
                                        .replacingOccurrences(of: "😠 ", with: "")
                                        .replacingOccurrences(of: "😨 ", with: "")
                                        .replacingOccurrences(of: "🤢 ", with: "")
                                        .replacingOccurrences(of: "😲 ", with: "")
                                        .lowercased()
                                    
                                    viewModel.globalEmotion = emotion
                                }
                            )
                            
                            // Language Filter
                            FilterActionButton(
                                title: "Language boost",
                                value: viewModel.globalLanguage.capitalized,
                                options: languages,
                                onSelect: { selected in
                                    viewModel.globalLanguage = selected
                                }
                            )
                            
                            // Channel Filter
                            FilterActionButton(
                                title: "Channel 🎧",
                                value: viewModel.globalChannel.capitalized,
                                options: channels,
                                onSelect: { selected in
                                    viewModel.globalChannel = selected
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 10)
                    .padding(.top, 6)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Voice sections
                VStack(spacing: 12) {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Clone voice entry point section (show if no cloned voices exist)
                            if viewModel.clonedVoices.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Create Your Voice")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                    
                                    VoiceCloneEntryPoint {
                                        startVoiceClone()
                                    }
                                    .padding(.horizontal, 10)
                                }
                            }
                            
                            // Cloned voices section (show if they exist)
                            if !viewModel.clonedVoices.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Your Cloned Voices")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            startVoiceClone()
                                        }) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.caption)
                                                Text("Clone More")
                                                    .font(.caption)
                                                    .fontWeight(.medium)
                                            }
                                            .foregroundColor(Color(red: 0.6, green: 0.8, blue: 1.0))
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.flexible(), spacing: 6),
                                        GridItem(.flexible(), spacing: 6)
                                    ], spacing: 6) {
                                        ForEach(viewModel.clonedVoices) { clonedVoice in
                                            ClonedVoiceGridItem(
                                                clonedVoice: clonedVoice,
                                                isSelected: (tempSelectedVoice?.voice_id ?? selectedVoice.voice_id) == clonedVoice.voiceID,
                                                isPlaying: viewModel.currentlyPlayingVoiceID == clonedVoice.voiceID,
                                                onTap: {
                                                    playHapticFeedback()
                                                    let voice = clonedVoice.toVoice()
                                                    tempSelectedVoice = voice
                                                    viewModel.showSelectButton = true
                                                    viewModel.playClonedVoicePreview(for: clonedVoice)
                                                },
                                                onDelete: {
                                                    playHapticFeedback()
                                                    viewModel.deleteClonedVoice(clonedVoice)
                                                }
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                }
                            }
                            
                            // Regular voices section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Available Voices")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 6),
                                    GridItem(.flexible(), spacing: 6)
                                ], spacing: 6) {
                                    ForEach(viewModel.voices) { voice in
                                        VoiceGridItem(
                                            voice: voice,
                                            isSelected: (tempSelectedVoice?.voice_id ?? selectedVoice.voice_id) == voice.voice_id,
                                            isPlaying: viewModel.currentlyPlayingVoiceID == voice.voice_id,
                                            isFree: viewModel.isVoiceFree(voice),
                                            isPremium: viewModel.purchaseVM.isPremium,
                                            onTap: {
                                                playHapticFeedback()
                                                // Do not open paywall on tap. Just select temporarily and preview
                                                tempSelectedVoice = voice
                                                viewModel.showSelectButton = true
                                                viewModel.playPreview(for: voice)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                
                if viewModel.showSelectButton, let tempVoice = tempSelectedVoice {
                    Button(action: {
                        playHapticFeedback()
                        // If premium required, show paywall on Select instead of on card tap
                        if viewModel.isVoiceFree(tempVoice) {
                            var newVoice = tempVoice
                            newVoice.emotion = viewModel.globalEmotion
                            newVoice.language = viewModel.globalLanguage
                            newVoice.channel = viewModel.globalChannel
                            selectedVoice = newVoice
                            isPresented = false
                            viewModel.stopPreview()
                        } else {
                            viewModel.stopPreview()
                            viewModel.showPaywall = true
                        }
                    }) {
                        Text("Select")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .navigationTitle("Voices")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        playHapticFeedback()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.showFilters.toggle()
                        }
                    }) {
                        Image("ic_slider")
                            .foregroundColor(.gray)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        playHapticFeedback()
                        isPresented = false
                        viewModel.stopPreview()
                    }) {
                        Image(systemName: "xmark").imageScale(.medium)
                            .foregroundColor(.gray)
                            .padding(.trailing, 6)
                    }
                }
            }
            .onAppear {
                tempSelectedVoice = selectedVoice
                // Initialize global filters with current voice settings
                viewModel.globalEmotion = selectedVoice.emotion
                viewModel.globalLanguage = selectedVoice.language
                viewModel.globalChannel = selectedVoice.channel
                
                // Refresh purchase status to ensure UI is up to date
                viewModel.purchaseVM.fetchPremiumStatus()
                
                // Load cloned voices
                viewModel.loadClonedVoices()
            }
            .onDisappear {
                viewModel.stopPreview()
                // Apply global filter settings to selectedVoice when dismissing
                selectedVoice.emotion = viewModel.globalEmotion
                selectedVoice.language = viewModel.globalLanguage
                selectedVoice.channel = viewModel.globalChannel
            }
        }
        .sheet(isPresented: $showVoiceSettingsGuidelines) {
            VoiceSettingsGuidelinesView()
        }
        .fullScreenCover(isPresented: $viewModel.showPaywall) {
            // Refresh purchase status when paywall is dismissed
            viewModel.purchaseVM.refreshPurchaseStatus()
        } content: {
            PaywallView()
        }
        .fullScreenCover(isPresented: $viewModel.showVoiceClone) {
            // Refresh cloned voices when voice clone view is dismissed
            viewModel.loadClonedVoices()
        } content: {
            VoiceCloneView()
        }
    }
    
    private func startVoiceClone() {
        playHapticFeedback()
        viewModel.stopPreview()
        viewModel.showVoiceClone = true
    }
    private func getEmotionDisplayValue(_ emotion: String) -> String {
        let emoji = emotions.first { $0.0 == emotion }?.1 ?? "🎭"
        return "\(emoji) \(emotion.capitalized)"
    }
}

// MARK: - Voice Settings Guidelines View
struct VoiceSettingsGuidelinesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Voice Settings Guide")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Learn how each setting affects your voice narration")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Settings explanations
                    VStack(spacing: 20) {
                        // Emotions
                        SettingExplanationCard(
                            title: "Emotions 🎭",
                            subtitle: "Speech emotion",
                            description: "Control the emotional tone of the narration. Choose from different emotions like happy, sad, angry, or let the AI automatically detect the most appropriate emotion for your story.",
                            examples: [
                                "😊 Happy - Perfect for cheerful stories",
                                "😢 Sad - Ideal for emotional moments",
                                "😐 Neutral - Balanced, natural tone",
                                "🎭 Auto - AI chooses the best emotion"
                            ]
                        )
                        
                        // Language Boost
                        SettingExplanationCard(
                            title: "Language Boost 🌍",
                            subtitle: "Enhance recognition of specific languages and dialects",
                            description: "Improve pronunciation and accent accuracy for specific languages. This helps the AI better understand and reproduce the nuances of different languages and regional accents.",
                            examples: [
                                "Automatic - Detects language automatically",
                                "English - Optimized for English pronunciation",
                                "Spanish - Enhanced Spanish accent",
                                "Chinese - Better Chinese character pronunciation"
                            ]
                        )
                        
                        // Channel
                        SettingExplanationCard(
                            title: "Channel 🎧",
                            subtitle: "Number of audio channels",
                            description: "Choose between mono (single channel) or stereo (dual channel) audio output. Stereo provides spatial audio effects while mono is more compatible with all devices.",
                            examples: [
                                "Mono - Single audio channel, universal compatibility",
                                "Stereo - Dual channels, spatial audio experience"
                            ]
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - Setting Explanation Card
struct SettingExplanationCard: View {
    let title: String
    let subtitle: String
    let description: String
    let examples: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Description
            Text(description)
                .font(.body)
                .foregroundColor(.primary)
            
            // Examples
            VStack(alignment: .leading, spacing: 8) {
                Text("Examples:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                ForEach(examples, id: \.self) { example in
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "arrowshape.right.fill").imageScale(.small)
                            .foregroundColor(.white)
                        
                        Text(example)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct FilterActionButton: View {
    let title: String
    let value: String
    let options: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        playHapticFeedback()
                        onSelect(option)
                    }) {
                        HStack {
                            Text(option.capitalized)
                            if value == option {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .font(.caption)
                            }
                        }
                    }
                }
            } label: {
                VStack(spacing: 4) {
                    Text(value)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.white))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct VoiceGridItem: View {
    let voice: Voice
    let isSelected: Bool
    let isPlaying: Bool
    let isFree: Bool
    let isPremium: Bool
    let onTap: () -> Void

    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .cornerRadius(12)
            
            VStack(spacing: 12) {
                ZStack {
                    let text = "• \(voice.preferredListenTime) •"
                    let characters = Array(text)
                    let radius: CGFloat = 58
                    let angle = 100.0 / Double(characters.count)

                    ForEach(0..<characters.count, id: \.self) { i in
                        let charAngle = Angle(degrees: Double(i) * angle - 190)
                        let xOffset = CGFloat(cos(charAngle.radians)) * radius
                        let yOffset = CGFloat(sin(charAngle.radians)) * radius

                        Text(String(characters[i]))
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .rotationEffect(charAngle + Angle(degrees: 90))
                            .offset(x: xOffset, y: yOffset)
                    }


                    if isSelected {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 96, height: 96)
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        Image(voice.voice_id)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                        
                        Image(systemName: "mic.circle.fill")
                            .imageScale(.medium)
                            .foregroundColor(.white)
                            .offset(x: 12, y: 6)
                    }
                }.background {
                    if isSelected, isPlaying {
                        AnimatedBackground()
                    }
                }
                
                VStack(spacing: 3) {
                    Text(voice.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(voice.description)
                        .font(.caption)
                        .foregroundColor(Color(.systemGray2))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .overlay(alignment: .topTrailing) {
            if !isPremium && isFree {
                Text("FREE")
                    .font(.caption2)
                    .foregroundColor(.green)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 1)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(4)
                    .padding(8)
            }
        }
    }
}

// MARK: - Morphing Blob Shape
struct BlobShape: Shape {
    var phase: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let base = min(rect.width, rect.height) * 0.45
        let waves = 1.0
        let steps = 60

        var path = Path()
        var first = true

        for i in 0...steps {
            let t = Double(i) / Double(steps) * 2 * .pi
            let offset = sin(waves * t + Double(phase)) * 8
            let radius = base + CGFloat(offset)

            let x = center.x + radius * cos(t)
            let y = center.y + radius * sin(t)

            if first {
                path.move(to: CGPoint(x: x, y: y))
                first = false
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}

struct AnimatedBackground: View {
    @State private var phase: CGFloat = 0
    @State private var pulse: CGFloat = 1

    var body: some View {
        ZStack {
            BlobShape(phase: phase)
                .fill(
                    LinearGradient(
                        colors: [
                            .indigo,
                            .orange
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: 12)
                .scaleEffect(pulse)
        }
        .frame(width: 110, height: 110)
        .onAppear {
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: true)) {
                phase = .pi * 2
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                pulse = 1.08
            }
        }
        .accessibilityHidden(true)
    }
}

#if DEBUG
#Preview {
    VoiceNameScreen(isPresented: .constant(true), selectedVoice: .constant(Voice.default))
}
#endif

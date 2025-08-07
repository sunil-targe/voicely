import SwiftUI
import AVFoundation

class VoiceNameViewModel: ObservableObject {
    @Published var voices: [Voice] = Voice.all
    @Published var selectedVoice: Voice?
    @Published var showSelectButton: Bool = false
    @Published var currentlyPlayingVoiceID: String? = nil
    @Published var showFilters: Bool = false
    @Published var globalEmotion: String = "auto"
    @Published var globalLanguage: String = "Automatic"
    @Published var globalChannel: String = "mono"
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        selectedVoice = voices.first
    }
    
    func selectVoice(_ voice: Voice) {
        selectedVoice = voice
        showSelectButton = true
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
}

struct VoiceNameScreen: View {
    @Binding var isPresented: Bool
    @Binding var selectedVoice: Voice
    @StateObject private var viewModel = VoiceNameViewModel()
    @State private var tempSelectedVoice: Voice?
    
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
                            Text("Voice settings")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
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
                
                // Voice grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 6),
                        GridItem(.flexible(), spacing: 6)
                    ], spacing: 6) {
                        ForEach(viewModel.voices) { voice in
                            VoiceGridItem(
                                voice: voice,
                                isSelected: (tempSelectedVoice?.voice_id ?? selectedVoice.voice_id) == voice.voice_id,
                                isPlaying: viewModel.currentlyPlayingVoiceID == voice.voice_id,
                                onTap: {
                                    playHapticFeedback()
                                    tempSelectedVoice = voice
                                    viewModel.showSelectButton = true
                                    viewModel.playPreview(for: voice)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                
                if viewModel.showSelectButton, let tempVoice = tempSelectedVoice {
                    Button(action: {
                        playHapticFeedback()
                        // Apply global filter settings to the selected voice
                        var newVoice = tempVoice
                        newVoice.emotion = viewModel.globalEmotion
                        newVoice.language = viewModel.globalLanguage
                        newVoice.channel = viewModel.globalChannel
                        selectedVoice = newVoice
                        isPresented = false
                        viewModel.stopPreview()
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

            }
            .onDisappear {
                viewModel.stopPreview()
                // Apply global filter settings to selectedVoice when dismissing
                selectedVoice.emotion = viewModel.globalEmotion
                selectedVoice.language = viewModel.globalLanguage
                selectedVoice.channel = viewModel.globalChannel
            }
        }
    }
    
    private func getEmotionDisplayValue(_ emotion: String) -> String {
        let emoji = emotions.first { $0.0 == emotion }?.1 ?? "🎭"
        return "\(emoji) \(emotion.capitalized)"
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
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Color(.secondarySystemBackground)
                    .cornerRadius(12)
                VStack(spacing: 12) {
                    // Voice Circle with Waveform - 1:1 aspect ratio
                    ZStack {
                        // Text around the circle
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
                                .foregroundColor(.white)
                                .rotationEffect(charAngle + Angle(degrees: 90))
                                .offset(x: xOffset, y: yOffset)
                        }

                        // Your original ZStack content
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

                            if isPlaying {
                                Image(systemName: "waveform.circle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(.white)
                                    .offset(x: 12, y: 6)
                            } else {
                                Image(systemName: "mic.circle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(.white)
                                    .offset(x: 12, y: 6)
                            }
                        }
                    }
                    
                    // Voice Name and Description
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
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if DEBUG
#Preview {
    VoiceNameScreen(isPresented: .constant(true), selectedVoice: .constant(Voice.default))
}
#endif

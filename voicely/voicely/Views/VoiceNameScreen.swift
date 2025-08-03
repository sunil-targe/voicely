import SwiftUI
import AVFoundation

class VoiceNameViewModel: ObservableObject {
    @Published var voices: [Voice] = Voice.all
    @Published var selectedVoice: Voice?
    @Published var showSelectButton: Bool = false
    @Published var currentlyPlayingVoiceID: String? = nil
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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
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
                        // Preserve filter values from previous selection
                        var newVoice = tempVoice
                        newVoice.emotion = selectedVoice.emotion
                        newVoice.language = selectedVoice.language
                        newVoice.channel = selectedVoice.channel
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
            }
            .onDisappear {
                viewModel.stopPreview()
            }
        }
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
                        Circle()
                            .fill(voice.color.color)
                            .frame(width: 90, height: 90)

                        if isPlaying {
                            Image(systemName: "waveform")
                                .font(.title)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "mic.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }

                        if isSelected {
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 96, height: 96)
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

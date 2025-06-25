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
                // Voice list
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.voices) { voice in
                            Button(action: {
                                playHapticFeedback()
                                tempSelectedVoice = voice
                                viewModel.showSelectButton = true
                                viewModel.playPreview(for: voice)
                            }) {
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(voice.color.color)
                                        .frame(width: 48, height: 48)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(voice.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(voice.description)
                                            .font(.subheadline)
                                            .foregroundColor(Color(.systemGray2))
                                    }
                                    Spacer()
                                    // Preview playing indicator
                                    if viewModel.currentlyPlayingVoiceID == voice.voice_id {
                                        Image(systemName: "waveform")
                                            .foregroundColor(.yellow)
                                    }
                                    if (tempSelectedVoice?.voice_id ?? selectedVoice.voice_id) == voice.voice_id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color.clear)
                            }
                        }
                    }
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
                            .padding(.bottom, 16)
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

#if DEBUG
#Preview {
    VoiceNameScreen(isPresented: .constant(true), selectedVoice: .constant(Voice.default))
}
#endif

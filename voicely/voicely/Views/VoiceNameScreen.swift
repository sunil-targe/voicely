import SwiftUI

class VoiceNameViewModel: ObservableObject {
    @Published var voices: [Voice] = Voice.all
    @Published var selectedVoice: Voice?
    @Published var showSelectButton: Bool = false
    
    init() {
        selectedVoice = voices.first
    }
    
    func selectVoice(_ voice: Voice) {
        selectedVoice = voice
        showSelectButton = true
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
                                tempSelectedVoice = voice
                                viewModel.showSelectButton = true
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
                                            .foregroundColor(Color(.systemGray3))
                                    }
                                    Spacer()
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
                        // Preserve filter values from previous selection
                        var newVoice = tempVoice
                        newVoice.emotion = selectedVoice.emotion
                        newVoice.language = selectedVoice.language
                        newVoice.channel = selectedVoice.channel
                        selectedVoice = newVoice
                        isPresented = false
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
                        isPresented = false
                    }) {
                        Image(systemName: "xmark").imageScale(.medium)
                            .foregroundColor(.white)
                            .padding(.trailing, 6)
                    }
                }
            }
            .onAppear {
                tempSelectedVoice = selectedVoice
            }
        }
    }
}

#if DEBUG
#Preview {
    VoiceNameScreen(isPresented: .constant(true), selectedVoice: .constant(Voice.default))
}
#endif

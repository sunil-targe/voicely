import SwiftUI

class VoiceNameViewModel: ObservableObject {
    @Published var voices: [Voice] = [
        Voice(id: UUID(), name: "Wise Woman", description: "Wise, mature, and gentle", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Wise_Woman"),
        Voice(id: UUID(), name: "Friendly Person", description: "Friendly and approachable", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.53)), voice_id: "Friendly_Person"),
        Voice(id: UUID(), name: "Inspirational Girl", description: "Inspiring and energetic", color: ColorCodable(color: Color(red: 0.67, green: 0.91, blue: 0.67)), voice_id: "Inspirational_girl"),
        Voice(id: UUID(), name: "Deep Voice Man", description: "Deep and powerful", color: ColorCodable(color: Color(red: 0.47, green: 0.81, blue: 0.98)), voice_id: "Deep_Voice_Man"),
        Voice(id: UUID(), name: "Calm Woman", description: "Calm and soothing", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)), voice_id: "Calm_Woman"),
        Voice(id: UUID(), name: "Casual Guy", description: "Casual and relaxed", color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)), voice_id: "Casual_Guy"),
        Voice(id: UUID(), name: "Lively Girl", description: "Lively and cheerful", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.98)), voice_id: "Lively_Girl"),
        Voice(id: UUID(), name: "Patient Man", description: "Patient and understanding", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Patient_Man"),
        Voice(id: UUID(), name: "Young Knight", description: "Young and brave", color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)), voice_id: "Young_Knight"),
        Voice(id: UUID(), name: "Determined Man", description: "Determined and strong", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)), voice_id: "Determined_Man"),
        Voice(id: UUID(), name: "Lovely Girl", description: "Lovely and sweet", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.53)), voice_id: "Lovely_Girl"),
        Voice(id: UUID(), name: "Decent Boy", description: "Decent and polite", color: ColorCodable(color: Color(red: 0.47, green: 0.81, blue: 0.98)), voice_id: "Decent_Boy"),
        Voice(id: UUID(), name: "Imposing Manner", description: "Imposing and authoritative", color: ColorCodable(color: Color(red: 0.67, green: 0.91, blue: 0.67)), voice_id: "Imposing_Manner"),
        Voice(id: UUID(), name: "Elegant Man", description: "Elegant and refined", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.98)), voice_id: "Elegant_Man"),
        Voice(id: UUID(), name: "Abbess", description: "Spiritual and wise", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Abbess"),
        Voice(id: UUID(), name: "Sweet Girl 2", description: "Sweet and gentle", color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)), voice_id: "Sweet_Girl_2"),
        Voice(id: UUID(), name: "Exuberant Girl", description: "Exuberant and lively", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)), voice_id: "Exuberant_Girl")
    ]
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
                        selectedVoice = tempVoice
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

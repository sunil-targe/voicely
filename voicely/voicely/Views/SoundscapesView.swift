import SwiftUI
import AVFoundation

struct SoundscapesView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSoundscape: SoundscapeType
    @StateObject private var mediaPlayerManager = MediaPlayerManager.shared


    
    enum SoundscapeType: String, CaseIterable {
        case mute = "Mute"
        case nature = "Nature"
        case water = "Water"
        case music = "Music"
        case coffee = "Coffee"
        case fire = "Fire"
        case sparkle = "Sparkle"
        case clock = "Clock"
        
        var icon: String {
            switch self {
            case .mute: return "speaker.slash.fill"
            case .nature: return "leaf.fill"
            case .water: return "wave.3.right"
            case .music: return "music.note"
            case .coffee: return "cup.and.saucer.fill"
            case .fire: return "flame.fill"
            case .sparkle: return "sparkles"
            case .clock: return "clock.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .mute: return .red
            case .nature: return .green
            case .water: return .blue
            case .music: return .purple
            case .coffee: return .brown
            case .fire: return .orange
            case .sparkle: return .yellow
            case .clock: return .gray
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Soundscape Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                    ForEach(SoundscapeType.allCases, id: \.self) { soundscape in
                        Button(action: {
                            selectedSoundscape = soundscape
                            playSoundscape(soundscape)
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: soundscape.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(mediaPlayerManager.currentSoundscape == soundscape ? .white : .white.opacity(0.7))
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Circle()
                                            .fill(mediaPlayerManager.currentSoundscape == soundscape ? soundscape.color : Color.clear)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                
                                Text(soundscape.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            // Sync the current soundscape with the selected one
            if mediaPlayerManager.currentSoundscape != selectedSoundscape {
                playSoundscape(selectedSoundscape)
            }
        }
        .onDisappear {
            // Ensure the selected soundscape is properly synced when view disappears
            if mediaPlayerManager.currentSoundscape != selectedSoundscape {
                mediaPlayerManager.playSoundscape(selectedSoundscape)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func playSoundscape(_ soundscape: SoundscapeType) {
        // Use the MediaPlayerManager to play the soundscape
        mediaPlayerManager.playSoundscape(soundscape)
    }
    

    
}

#Preview {
    SoundscapesView(selectedSoundscape: .constant(.mute))
}

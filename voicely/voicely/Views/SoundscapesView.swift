import SwiftUI

struct SoundscapesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSoundscape: SoundscapeType = .mute
    @State private var timerDuration: TimeInterval = 25 * 60 // 25 minutes in seconds
    @State private var isTimerRunning = false
    
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
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
          
                VStack(spacing: 0) {
                    // Header
                    HStack {
                 
                        Text("Soundscapes")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Soundscape Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                        ForEach(SoundscapeType.allCases, id: \.self) { soundscape in
                            Button(action: {
                                selectedSoundscape = soundscape
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: soundscape.icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(selectedSoundscape == soundscape ? .white : .black)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .fill(selectedSoundscape == soundscape ? soundscape.color : Color.clear)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                    
                                    Text(soundscape.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        
    }
    
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    SoundscapesView()
}

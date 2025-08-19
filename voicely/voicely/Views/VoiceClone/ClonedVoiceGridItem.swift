import SwiftUI

struct ClonedVoiceGridItem: View {
    let clonedVoice: ClonedVoice
    let isSelected: Bool
    let isPlaying: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .cornerRadius(12)
            
            VStack(spacing: 12) {
                ZStack {
                    // Circular text animation
                    let text = "• YOUR VOICE •"
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
                            .foregroundColor(Color(red: 0.6, green: 0.8, blue: 1.0))
                            .rotationEffect(charAngle + Angle(degrees: 90))
                            .offset(x: xOffset, y: yOffset)
                    }

                    if isSelected {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 96, height: 96)
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        // Clone voice avatar
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.6, green: 0.8, blue: 1.0),
                                    Color(red: 0.4, green: 0.6, blue: 0.9)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 90, height: 90)
                            .overlay(
                                Image(systemName: "person.wave.2.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                            )
                        
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
                
                VStack(spacing: 3) {
                    Text(clonedVoice.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text("Your cloned voice")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray2))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(.vertical)
            
            // More button (top right)
            VStack {
                HStack {
                    Spacer()
                    Menu {
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Label("Delete Voice", systemImage: "trash")
                        }
                        .foregroundColor(.red)
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .padding(8)
                    }
                }
                Spacer()
            }
            
            // Clone badge (top left)
            VStack {
                HStack {
                    Text("CLONE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 20)
                        .background(Color(red: 0.6, green: 0.8, blue: 1.0))
                        .cornerRadius(4)
                        .padding(.leading, 8)
                        .padding(.top, 8)
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(width: 160, height: 160) // Fixed size for horizontal scrolling
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .alert("Delete Cloned Voice", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete '\(clonedVoice.name)'? This action cannot be undone.")
        }
    }
}

#if DEBUG
#Preview {
    ClonedVoiceGridItem(
        clonedVoice: ClonedVoice(
            id: UUID(),
            name: "My Voice",
            voiceID: "test_voice_id",
            audioData: Data(),
            createdAt: Date()
        ),
        isSelected: false,
        isPlaying: false,
        onTap: {},
        onDelete: {}
    )
    .background(Color.black)
    .padding()
}
#endif

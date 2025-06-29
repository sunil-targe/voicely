import SwiftUI

struct EmptyHistoryView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "waveform")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(.white.opacity(0.18))
            Text("No Voices Yet")
                .font(.title2).fontWeight(.bold)
                .foregroundColor(.white.opacity(0.9))
            Text("Your generated voices will appear here.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button(action: {
                isPresented = false
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles").imageScale(.medium)
                        .padding(.leading)
                    Text("Generate your first voice")
                        .fontWeight(.semibold)
                        .padding(.trailing)
                        .padding(.vertical, 14)
                }
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(14)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct HistoryScreen: View {
    @Binding var isPresented: Bool
    let history: [HistoryItem]
    @State private var selectedItem: HistoryItem? = nil
    @State private var showPlayer: Bool = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if !history.isEmpty {
                    EmptyHistoryView(isPresented: $isPresented)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(history) { item in
                                Button(action: {
                                    selectedItem = item
                                    withAnimation { showPlayer = true }
                                }) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Circle().fill(item.voice.color.color).frame(width: 24, height: 24)
                                            Text(item.voice.name)
                                                .foregroundColor(.white)
                                                .font(.subheadline)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                        Text(item.text)
                                            .foregroundColor(.white)
                                            .font(.title3)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                        Text("\(item.date, formatter: dateFormatter) · Text To Speech")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Divider()
                            }
                        }
                        .padding(.top)
                    }
                }
                
                // PlayerView overlay
                if let item = selectedItem, showPlayer {
                    PlayerView(
                        text: item.text,
                        voice: item.voice,
                        audioURL: item.audioURL,
                        localAudioFilename: item.localAudioFilename,
                        onClose: {
                            withAnimation {
                                showPlayer = false
                                selectedItem = nil
                            }
                        }
                    )
                    .id(item.id)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
                }
            }
            .navigationTitle("History")
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
        }
    }
}

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    df.doesRelativeDateFormatting = true
    return df
}()

#if DEBUG
#Preview {
    let sampleVoice = Voice.default
    let sampleHistory: [HistoryItem] = [
        HistoryItem(
            id: UUID(),
            text: "Once",
            voice: sampleVoice,
            audioURL: URL(string: "https://replicate.delivery/xezq/hKXWcfOQBfkqjUWeBbAPRy3F3dl9sVS3wUZlfJWkp6FZYzpTB/tmpw8d9j_p4.mp3")!,
            localAudioFilename: nil,
            date: Date(),
            emotion: "auto",
            language: "None",
            channel: "mono"
        ),
        HistoryItem(
            id: UUID(),
            text: "Once upon a time, a little bunny named Coco found a magic carrot in the garden 2.",
            voice: sampleVoice,
            audioURL: URL(string: "https://replicate.delivery/xezq/hKXWcfOQBfkqjUWeBbAPRy3F3dl9sVS3wUZlfJWkp6FZYzpTB/tmpw8d9j_p4.mp3")!,
            localAudioFilename: nil,
            date: Date(),
            emotion: "auto",
            language: "None",
            channel: "mono"
        )
    ]
    return HistoryScreen(isPresented: .constant(true), history: sampleHistory)
}
#endif 

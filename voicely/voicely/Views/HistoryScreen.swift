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
            Text("No Stories Yet")
                .font(.title2).fontWeight(.bold)
                .foregroundColor(.white.opacity(0.9))
            Text("Your generated stories will appear here.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button(action: {
                playHapticFeedback()
                isPresented = false
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles").imageScale(.medium)
                        .padding(.leading)
                    Text("Generate your first story")
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
    @Binding var history: [HistoryItem]
    @State private var selectedItem: HistoryItem? = nil
    @State private var showPlayer: Bool = false
    @State private var isEditing = false
    @State private var selectedIDs = Set<UUID>()
    @State private var recentlyDeleted: [HistoryItem] = []
    @State private var showUndoBanner = false
    @State private var undoTimer: Timer? = nil

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if history.isEmpty {
                    EmptyHistoryView(isPresented: $isPresented)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(history) { item in
                                Button(action: {
                                    playHapticFeedback()
                                    if isEditing {
                                        if selectedIDs.contains(item.id) {
                                            selectedIDs.remove(item.id)
                                        } else {
                                            selectedIDs.insert(item.id)
                                        }
                                    } else {
                                        selectedItem = item
                                        withAnimation { showPlayer = true }
                                    }
                                }) {
                                    HStack(alignment: .center, spacing: 0) {
                                        if isEditing {
                                            Image(systemName: selectedIDs.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedIDs.contains(item.id) ? .white : .gray)
                                                .font(.title2)
                                                .padding(.leading)
                                        }
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(item.text)
                                                .foregroundColor(.white)
                                                .font(.title3)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(2)
                                            HStack {
                                                // selected voice
                                                HStack {
                                                    Circle().fill(item.voice.color.color)
                                                        .frame(width: 20, height: 20)
                                                        .overlay(
                                                            Image(systemName: "mic.fill")
                                                                .foregroundColor(.white)
                                                                .font(.system(size: 10))
                                                        )
                                                    
                                                    Text(item.voice.name)
                                                        .foregroundColor(.white.opacity(0.7))
                                                        .font(.caption2)
                                                }
                                                .padding(.horizontal, 9)
                                                .padding(.vertical, 4)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                                )
                                                
                                                // time
                                                Text("\(item.date, formatter: dateFormatter)")
                                                    .foregroundColor(.gray)
                                                    .font(.caption)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                Divider()
                            }
                        }
                        .padding(.top)
                    }
                    if isEditing && !selectedIDs.isEmpty {
                        Button(action: {
                            playHapticFeedback()
                            // Store deleted items for undo
                            recentlyDeleted = history.filter { selectedIDs.contains($0.id) }
                            history.removeAll { selectedIDs.contains($0.id) }
                            HistoryStorage.save(history)
                            selectedIDs.removeAll()
                            isEditing = false
                            // Show undo banner
                            showUndoBanner = true
                            // Start timer to auto-dismiss
                            undoTimer?.invalidate()
                            undoTimer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { _ in
                                showUndoBanner = false
                                recentlyDeleted = []
                            }
                        }) {
                            Text("Delete (\(selectedIDs.count))")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .cornerRadius(14)
                                .padding(.bottom, 24)
                        }
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                
                // PlayerView overlay
                if let item = selectedItem, showPlayer {
                    VoicelyPlayer.PlayerView(
                        text: item.text,
                        voice: item.voice,
                        audioURL: item.audioURL,
                        localAudioFilename: item.localAudioFilename,
                        onClose: {
                            withAnimation {
                                showPlayer = false
                                selectedItem = nil
                            }
                        },
                        style: .TextToSpeech
                    )
                    .id(item.id)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
                }
                
                // Undo Snackbar/Banner
                if showUndoBanner && !recentlyDeleted.isEmpty {
                    HStack {
                        Text("Deleted \(recentlyDeleted.count) item\(recentlyDeleted.count > 1 ? "s" : "")")
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            playHapticFeedback()
                            // Undo deletion
                            history.insert(contentsOf: recentlyDeleted, at: 0)
                            HistoryStorage.save(history)
                            recentlyDeleted = []
                            showUndoBanner = false
                            undoTimer?.invalidate()
                        }) {
                            Text("Undo")
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(14)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
                }
            }
            .navigationTitle("Your Stories")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                if !history.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            playHapticFeedback()
                            isEditing.toggle()
                            if !isEditing { selectedIDs.removeAll() }
                        }) {
                            Text(isEditing ? "Done" : "Edit")
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        playHapticFeedback()
                        isPresented = false
                    }) {
                        Image(systemName: "xmark").imageScale(.medium)
                            .foregroundColor(.gray)
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
    return HistoryScreen(isPresented: .constant(true), history: .constant(sampleHistory))
}
#endif 

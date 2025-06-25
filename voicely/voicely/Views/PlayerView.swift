import SwiftUI
import AVFoundation

// Helper class for KVO observation
class PlayerItemStatusObserver: NSObject, ObservableObject {
    var statusChanged: ((AVPlayerItem.Status) -> Void)?
    private var observedItem: AVPlayerItem?
    private var context = 0

    func observe(item: AVPlayerItem) {
        observedItem = item
        item.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: &context)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let item = object as? AVPlayerItem {
            statusChanged?(item.status)
        }
    }

    func invalidate() {
        if let item = observedItem {
            item.removeObserver(self, forKeyPath: "status")
            observedItem = nil
        }
    }
}

struct PlayerView: View {
    let text: String
    let voice: Voice
    let audioURL: URL
    let localAudioFilename: String?
    var onClose: (() -> Void)? = nil

    @State private var player: AVPlayer? = nil
    @State private var isPlaying = false
    @State private var duration: Double = 0
    @State private var currentTime: Double = 0
    @State private var timeObserver: Any?
    @State private var showShareSheet = false
    @State private var playerStatus: AVPlayerItem.Status = .unknown
    @StateObject private var statusObserver = PlayerItemStatusObserver()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var activityItems: [Any] = []

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(text)
                        .font(.title3)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.top, 6)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            onClose?()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                }
                // Progress bar
                HStack {
                    Text(timeString(currentTime))
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Slider(value: $currentTime, in: 0...duration, onEditingChanged: sliderChanged)
                        .accentColor(.white)
                    Text(timeString(duration))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 2)
                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Circle().fill(voice.color.color).frame(width: 24, height: 24)
                        Text(voice.name)
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    Spacer()
                    Button(action: togglePlay) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.black)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.white))
                    }
                    .disabled(playerStatus != .readyToPlay)
                    if let filename = localAudioFilename {
                        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = docs.appendingPathComponent(filename)
                        if FileManager.default.fileExists(atPath: fileURL.path) {
                            ShareLink(item: fileURL) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.black)
                                    .frame(width: 32, height: 32)
                                    .background(Circle().fill(Color.white))
                            }
                        }
                    }
                }
                .padding(.bottom, 6)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            .cornerRadius(14)
        }
        .padding(.horizontal)
        .onAppear(perform: setupPlayer)
        .onDisappear(perform: cleanupPlayer)
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Playback Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func setupPlayer() {
        // Determine the correct URL to use
        var resolvedURL = audioURL
        if let filename = localAudioFilename {
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docs.appendingPathComponent(filename)
            let exists = FileManager.default.fileExists(atPath: fileURL.path)
            print("Checking for local audio file at: \(fileURL.path), exists: \(exists)")
            if exists {
                resolvedURL = fileURL
            } else {
                print("Local audio file missing, falling back to remote URL.")
            }
        }
        print("Attempting to play audioURL: \(resolvedURL)")
        if resolvedURL.isFileURL {
            let exists = FileManager.default.fileExists(atPath: resolvedURL.path)
            print("File exists at path: \(resolvedURL.path): \(exists)")
            if !exists {
                errorMessage = "Audio file does not exist at path: \(resolvedURL.lastPathComponent). It may not have downloaded correctly. Please try regenerating."
                showErrorAlert = true
                return
            }
        }
        DispatchQueue.main.async {
            let player = AVPlayer(url: resolvedURL)
            self.player = player

            if let item = player.currentItem {
                statusObserver.observe(item: item)
                statusObserver.statusChanged = { status in
                    self.playerStatus = status
                    if status == .readyToPlay {
                        if let duration = self.player?.currentItem?.asset.duration.seconds, duration > 0, duration.isFinite {
                            self.startPlayback()
                        } else {
                            print("Audio file has zero or invalid duration.")
                            errorMessage = "Audio file has zero or invalid duration."
                            showErrorAlert = true
                        }
                    } else if status == .failed {
                        let errDesc = self.player?.currentItem?.error?.localizedDescription ?? "Unknown error"
                        print("Failed to load audio: \(String(describing: self.player?.currentItem?.error))")
                        errorMessage = "Failed to load audio: \(errDesc)"
                        showErrorAlert = true
                    }
                }

                // Set up time observer
                timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
                    currentTime = time.seconds
                    if let duration = player.currentItem?.duration.seconds, currentTime >= duration {
                        isPlaying = false
                    }
                }

                if item.status == .readyToPlay {
                    if let duration = self.player?.currentItem?.asset.duration.seconds, duration > 0, duration.isFinite {
                        self.startPlayback()
                    } else {
                        print("Audio file has zero or invalid duration.")
                        errorMessage = "Audio file has zero or invalid duration."
                        showErrorAlert = true
                    }
                }
            }
        }
    }

    private func startPlayback() {
        guard let player = player,
              let item = player.currentItem,
              item.status == .readyToPlay,
              item.asset.duration.seconds.isFinite,
              item.asset.duration.seconds > 0 else {
            print("Player not ready or duration invalid.")
            return
        }
        player.play()
        isPlaying = true
        duration = item.asset.duration.seconds
    }

    private func cleanupPlayer() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        statusObserver.invalidate()
        player?.pause()
        player = nil
    }

    private func togglePlay() {
        guard let player = player, player.currentItem?.status == .readyToPlay else { return }
        if isPlaying {
            player.pause()
        } else {
            // If playback finished, reset to beginning
            if currentTime >= duration {
                player.seek(to: .zero)
                currentTime = 0
            } else {
                player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
            }
            player.play()
        }
        isPlaying.toggle()
    }

    private func sliderChanged(editing: Bool) {
        guard let player = player else { return }
        if editing == false {
            player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
        }
    }

    private func timeString(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "00:00" }
        let intSec = Int(seconds)
        let min = intSec / 60
        let sec = intSec % 60
        return String(format: "%02d:%02d", min, sec)
    }
}

#if DEBUG
#Preview {
    VStack {
        PlayerView(
            text: "Heyyyyy ",
            voice: Voice.default,
            audioURL: URL(string: "https://replicate.delivery/xezq/hKXWcfOQBfkqjUWeBbAPRy3F3dl9sVS3wUZlfJWkp6FZYzpTB/tmpw8d9j_p4.mp3")!,
            localAudioFilename: nil,
            onClose: { }
        )
    }
    .background(Color.black)
}
#endif

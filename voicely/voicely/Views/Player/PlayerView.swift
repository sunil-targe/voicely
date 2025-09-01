import SwiftUI
import AVFoundation
import MediaPlayer
import DesignSystem

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

extension VoicelyPlayer {
    struct PlayerView: View {
        @EnvironmentObject var mainVM: MainViewModel
        
        let text: String
        let voice: Voice
        let audioURL: URL
        let localAudioFilename: String?
        var onClose: (() -> Void)? = nil
        let style: VoicelyPlayer.Style
        
        @State private var player: AVPlayer? = nil
        @State private var isPlaying = false
        @State private var duration: Double = 0
        @State private var currentTime: Double = 0
        @State private var timeObserver: Any?
        @State private var playerStatus: AVPlayerItem.Status = .unknown
        @StateObject private var statusObserver = PlayerItemStatusObserver()
        @EnvironmentObject var mediaPlayerManager: MediaPlayerManager
        @State private var showErrorAlert = false
        @State private var errorMessage = ""
        @State private var showFullText = false
        @State private var showSpeedControl = false
        @StateObject private var speedManager = PlaybackSpeedManager()
        
        var body: some View {
            VStack(spacing: 0) {
                Divider()
                
                PlayerHeaderView(
                    style: style,
                    voice: voice,
                    localAudioFilename: localAudioFilename,
                    onClose: onClose
                )
                
                PlayerProgressView(
                    currentTime: $currentTime,
                    duration: duration,
                    onSliderChanged: sliderChanged
                )
                
                PlayerControlsView(
                    playerStatus: playerStatus,
                    isPlaying: $isPlaying,
                    speedText: speedText,
                    localAudioFilename: localAudioFilename,
                    onSeekBackward: seekBackward,
                    onTogglePlay: togglePlay,
                    onSeekForward: seekForward,
                    onToggleSpeed: togglePlaybackSpeed
                )
            }
            .background(Color(.secondarySystemBackground))
            .onAppear(perform: setupPlayer)
            .onDisappear(perform: cleanupPlayer)
            .onReceive(mediaPlayerManager.$isPlaying) { newValue in
                isPlaying = newValue
            }
            .onReceive(mediaPlayerManager.$currentTime) { newValue in
                currentTime = newValue
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Playback Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showFullText) {
                PreviewText(text: text, isPresenting: $showFullText)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showSpeedControl) {
                SpeedControlModal(
                    currentSpeed: $speedManager.currentSpeed,
                    isPresented: $showSpeedControl,
                    onSpeedChanged: { newSpeed in
                        speedManager.updateSpeed(newSpeed)
                        player?.rate = Float(newSpeed)
                    },
                    originalDuration: duration
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        
        // MARK: - Computed Properties
        private var speedText: String {
            return String(format: "%.1fx", speedManager.currentSpeed)
        }
        
        // MARK: - Player Control Methods
        private func togglePlaybackSpeed() {
            showSpeedControl = true
        }
        
        private func seekForward() {
            guard let player = player else { return }
            let newTime = min(currentTime + 10, duration)
            player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
            currentTime = newTime
            mediaPlayerManager.seek(to: newTime)
        }
        
        private func seekBackward() {
            guard let player = player else { return }
            let newTime = max(currentTime - 10, 0)
            player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
            currentTime = newTime
            mediaPlayerManager.seek(to: newTime)
        }
        
        private func setupPlayer() {
            AudioSessionManager.shared.configureAudioSession()
            
            var resolvedURL = audioURL
            if let filename = localAudioFilename {
                let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = docs.appendingPathComponent(filename)
                let exists = FileManager.default.fileExists(atPath: fileURL.path)
                if exists {
                    resolvedURL = fileURL
                }
            }
            
            if resolvedURL.isFileURL {
                let exists = FileManager.default.fileExists(atPath: resolvedURL.path)
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
                                self.errorMessage = "Audio file has zero or invalid duration."
                                self.showErrorAlert = true
                            }
                        } else if status == .failed {
                            let errDesc = self.player?.currentItem?.error?.localizedDescription ?? "Unknown error"
                            self.errorMessage = "Failed to load audio: \(errDesc)"
                            self.showErrorAlert = true
                        }
                    }
                    
                    timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
                        currentTime = time.seconds
                        if let duration = player.currentItem?.duration.seconds, currentTime >= duration {
                            isPlaying = false
                            mediaPlayerManager.pauseStory()
                            // Restore soundscape volume when story ends naturally
                            mediaPlayerManager.restoreSoundscapeVolume()
                        }
                        mediaPlayerManager.updateDuration(duration)
                    }
                    
                    if item.status == .readyToPlay {
                        if let duration = self.player?.currentItem?.asset.duration.seconds, duration > 0, duration.isFinite {
                            self.startPlayback()
                        } else {
                            self.errorMessage = "Audio file has zero or invalid duration."
                            self.showErrorAlert = true
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
                return
            }
            
            mediaPlayerManager.configurePlayer(player, title: text, voiceName: voice.name)
            mediaPlayerManager.updateDuration(item.asset.duration.seconds)
            
            // Adjust soundscape volume for story playback
            mediaPlayerManager.adjustSoundscapeVolumeForStoryPlayback()
            
            if #available(iOS 16.1, *) {
                DynamicIslandManager.shared.startActivity(
                    title: text,
                    voiceName: voice.name,
                    isPlaying: true,
                    currentTime: 0,
                    duration: item.asset.duration.seconds
                )
            }
            
            player.play()
            player.rate = Float(speedManager.currentSpeed)
            isPlaying = true
            duration = item.asset.duration.seconds
            mediaPlayerManager.playStory()
        }
        
        private func cleanupPlayer() {
            if let observer = timeObserver {
                player?.removeTimeObserver(observer)
                timeObserver = nil
            }
            statusObserver.invalidate()
            
            // Restore soundscape volume before stopping story audio
            mediaPlayerManager.restoreSoundscapeVolume()
            mediaPlayerManager.stopStoryAudioOnly() // Use new method to keep soundscape playing
            
            if #available(iOS 16.1, *) {
                DynamicIslandManager.shared.endActivity()
            }
            
            // Keep the audio session active if a soundscape is selected
            if mediaPlayerManager.currentSoundscape == .mute {
                AudioSessionManager.shared.deactivateAudioSession()
            } else {
                // Reconfigure for soundscape and make sure it is playing
                AudioSessionManager.shared.configureAudioSessionForSoundscape()
                mediaPlayerManager.ensureSoundscapePlaying()
            }
            player?.pause()
            player = nil
        }
        
        private func togglePlay() {
            guard let player = player, player.currentItem?.status == .readyToPlay else { return }
            if isPlaying {
                player.pause()
                mediaPlayerManager.pauseStory()
                
                // Restore soundscape volume when story is paused
                mediaPlayerManager.restoreSoundscapeVolume()
                
                if #available(iOS 16.1, *) {
                    DynamicIslandManager.shared.updateActivity(
                        isPlaying: false,
                        currentTime: currentTime,
                        duration: duration
                    )
                }
            } else {
                if currentTime >= duration {
                    player.seek(to: .zero)
                    currentTime = 0
                } else {
                    player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                }
                player.play()
                player.rate = Float(speedManager.currentSpeed)
                mediaPlayerManager.playStory()
                
                // Adjust soundscape volume when story resumes
                mediaPlayerManager.adjustSoundscapeVolumeForStoryPlayback()
                
                if #available(iOS 16.1, *) {
                    DynamicIslandManager.shared.updateActivity(
                        isPlaying: true,
                        currentTime: currentTime,
                        duration: duration
                    )
                }
            }
            isPlaying.toggle()
        }
        
        private func sliderChanged(editing: Bool) {
            guard let player = player else { return }
            if editing == false {
                player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                mediaPlayerManager.seek(to: currentTime)
                
                if #available(iOS 16.1, *) {
                    DynamicIslandManager.shared.updateActivity(
                        isPlaying: isPlaying,
                        currentTime: currentTime,
                        duration: duration
                    )
                }
            }
        }
    }
    
    struct PreviewText: View {
        let text: String
        @Binding var isPresenting: Bool
        @State private var isCopied = false
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        playHapticFeedback()
                        withAnimation {
                            isPresenting = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding([.horizontal, .top])
                
                ScrollView {
                    Text(text)
                        .font(.title3)
                        .minimumScaleFactor(0.8)
                        .textSelection(.enabled)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    UIPasteboard.general.string = text
                    isCopied = true
                    playHapticFeedback()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isCopied = false
                    }
                }) {
                    Text(isCopied ? "Copied" : "Copy")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding()
            }
        }
    }
}

#if DEBUG
#Preview {
    VStack {
        VoicelyPlayer.PlayerView(
            text: "Heyyyyy ",
            voice: Voice.default,
            audioURL: URL(string: "https://replicate.delivery/xezq/hKXWcfOQBfkqjUWeBbAPRy3F3dl9sVS3wUZlfJWkp6FZYzpTB/tmpw8d9j_p4.mp3")!,
            localAudioFilename: nil,
            onClose: { },
            style: .ReadBook
        ).environmentObject(MainViewModel(selectedVoice: Voice.default))
    }
    .background(Color.black)
}
#endif

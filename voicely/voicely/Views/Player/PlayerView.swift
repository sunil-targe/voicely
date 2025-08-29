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

// MARK: - Player Subviews

private struct PlayerHeaderView: View {
    @EnvironmentObject var mainVM: MainViewModel
    
    let style: VoicelyPlayer.Style
    let voice: Voice
    let localAudioFilename: String?
    let onClose: (() -> Void)?
        
    var body: some View {
        HStack {
            VoiceSelectionButton(
                color: voice.color.color,
                title: voice.name,
                style: .plain
            )
            
            Spacer()
            
            if onClose != nil {
                Button(action: {
                    playHapticFeedback()
                    withAnimation {
                        onClose?()
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

private struct PlayerProgressView: View {
    @Binding var currentTime: Double
    let duration: Double
    let onSliderChanged: (Bool) -> Void
    
    var body: some View {
        HStack {
            Text(timeString(currentTime))
                .font(.caption)
                .foregroundColor(.gray)
            
            Slider(value: $currentTime, in: 0...duration, onEditingChanged: onSliderChanged)
                .accentColor(.blue)
            
            Text(timeString(duration))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func timeString(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "00:00" }
        let intSec = Int(seconds)
        let min = intSec / 60
        let sec = intSec % 60
        return String(format: "%02d:%02d", min, sec)
    }
}

private struct PlayerControlsView: View {
    let playerStatus: AVPlayerItem.Status
    @Binding var isPlaying: Bool
    let speedText: String
    let localAudioFilename: String?
    
    let onSeekBackward: () -> Void
    let onTogglePlay: () -> Void
    let onSeekForward: () -> Void
    let onToggleSpeed: () -> Void
    @EnvironmentObject var mediaPlayerManager: MediaPlayerManager
    
    var body: some View {
        HStack(spacing: 30) {
            // Menu button
            Menu {
                if let filename = localAudioFilename,
                   let fileURL = getLocalFileURL(for: filename) {
                    ShareLink(item: fileURL) {
                        HStack{
                            Text("Share Audio")
                            Image("ic_share")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                // Sleep Timer submenu
                Menu {
                    Button("30 minutes") { setSleep(minutes: 30) }
                    Button("20 minutes") { setSleep(minutes: 20) }
                    Button("10 minutes") { setSleep(minutes: 10) }
                    Button("5 minutes") { setSleep(minutes: 5) }
                    if mediaPlayerManager.sleepTimerRemainingSeconds != nil {
                        Divider()
                        Button("Cancel Sleep Timer") { mediaPlayerManager.cancelSleepTimer() }
                    }
                } label: {
                    Label(getSleepTimerDisplayText(), systemImage: "moon")
                }
            } label: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Rewind 10s
            Button(action: {
                playHapticFeedback()
                onSeekBackward()
            }) {
                Image(systemName: "gobackward.10")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            
            // Play/Pause button
            Button(action: {
                playHapticFeedback()
                onTogglePlay()
            }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(.white)
                    .font(.title)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.blue))
            }
            .disabled(playerStatus != .readyToPlay)
            
            // Fast forward 10s
            Button(action: {
                playHapticFeedback()
                onSeekForward()
            }) {
                Image(systemName: "goforward.10")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            
            // Speed control
            Button(action: {
                playHapticFeedback()
                onToggleSpeed()
            }) {
                Text(speedText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.gray.opacity(0.3)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private func getLocalFileURL(for filename: String) -> URL? {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docs.appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
    
    private func setSleep(minutes: Int) {
        let seconds = TimeInterval(minutes * 60)
        mediaPlayerManager.setSleepTimer(seconds: seconds)
    }
    
    private func getSleepTimerDisplayText() -> String {
        guard let remainingSeconds = mediaPlayerManager.sleepTimerRemainingSeconds else {
            return "Sleep Time"
        }
        
        let minutes = Int(remainingSeconds) / 60
        let seconds = Int(remainingSeconds) % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
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
        @State private var playbackSpeed: Double = 1.0
        @State private var showFullText = false
        @State private var showSpeedControl = false
        
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
                    currentSpeed: $playbackSpeed,
                    isPresented: $showSpeedControl,
                    onSpeedChanged: { newSpeed in
                        playbackSpeed = newSpeed
                        player?.rate = Float(playbackSpeed)
                    },
                    originalDuration: duration
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        
        // MARK: - Computed Properties
        private var speedText: String {
            return String(format: "%.1fx", playbackSpeed)
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
            player.rate = Float(playbackSpeed)
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
                player.rate = Float(playbackSpeed)
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
    
    struct SpeedControlModal: View {
        @Binding var currentSpeed: Double
        @Binding var isPresented: Bool
        let onSpeedChanged: (Double) -> Void
        let originalDuration: Double // Original duration in seconds
        
        private let speedOptions: [Double] = [0.5, 0.8, 1.0, 1.2, 1.5, 2.0, 3.0, 3.5, 4.0]
        private let minSpeed: Double = 0.5
        private let maxSpeed: Double = 4.0
        private let speedStep: Double = 0.1
        
        // Computed property for adjusted duration
        private var adjustedDuration: Double {
            return originalDuration / currentSpeed
        }
        
        // Computed property for duration string
        private var durationString: String {
            let hours = Int(adjustedDuration) / 3600
            let minutes = (Int(adjustedDuration) % 3600) / 60
            let seconds = Int(adjustedDuration) % 60
            
            if hours > 0 {
                return String(format: "~%02d:%02d:%02d", hours, minutes, seconds)
            } else {
                return String(format: "~%02d:%02d", minutes, seconds)
            }
        }
        
        var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Drag indicator
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 36, height: 5)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    
                    // Header
                    HStack {
                        Text("Playback Speed")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            playHapticFeedback()
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                    
                    // Duration info
                    HStack {
                        Text("Duration: \(durationString)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    
                    // Main content with custom slider on the right
                    HStack(alignment: .top, spacing: 20) {
                        // Left side - Main controls
                        VStack(spacing: 24) {
                            // Speed adjustment buttons and display
                            HStack(spacing: 40) {
                                // Decrease speed button
                                Button(action: {
                                    playHapticFeedback()
                                    decreaseSpeed()
                                }) {
                                    Image(systemName: "minus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Circle().fill(Color.gray.opacity(0.3)))
                                }
                                .disabled(currentSpeed <= minSpeed)
                                
                                // Current speed display
                                Text(String(format: "%.1fx", currentSpeed))
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .frame(minWidth: 120)
                                
                                // Increase speed button
                                Button(action: {
                                    playHapticFeedback()
                                    increaseSpeed()
                                }) {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Circle().fill(Color.gray.opacity(0.3)))
                                }
                                .disabled(currentSpeed >= maxSpeed)
                            }
                            
                            // Quick select speed options in rows of 3
                            VStack(spacing: 12) {
                                // First row: 0.5x, 0.8x, 1.0x
                                HStack(spacing: 12) {
                                    ForEach(Array(speedOptions.prefix(3)), id: \.self) { speed in
                                        SpeedButton(
                                            speed: speed,
                                            isSelected: currentSpeed == speed,
                                            action: { selectSpeed(speed) }
                                        )
                                    }
                                }
                                
                                // Second row: 1.2x, 1.5x, 2.0x
                                HStack(spacing: 12) {
                                    ForEach(Array(speedOptions.dropFirst(3).prefix(3)), id: \.self) { speed in
                                        SpeedButton(
                                            speed: speed,
                                            isSelected: currentSpeed == speed,
                                            action: { selectSpeed(speed) }
                                        )
                                    }
                                }
                                
                                // Third row: 4.0x (centered)
                                HStack(spacing: 12) {
                                    if speedOptions.count > 6 {
                                        ForEach(Array(speedOptions.dropFirst(6)), id: \.self) { speed in
                                            SpeedButton(
                                                speed: speed,
                                                isSelected: currentSpeed == speed,
                                                action: { selectSpeed(speed) }
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Right side - Custom vertical slider
                        VStack {
                            CustomVerticalSlider(
                                value: $currentSpeed,
                                range: minSpeed...maxSpeed,
                                step: speedStep,
                                onValueChanged: { newValue in
                                    onSpeedChanged(newValue)
                                }
                            )
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
        }
        
        private func decreaseSpeed() {
            let newSpeed = max(currentSpeed - speedStep, minSpeed)
            updateSpeed(newSpeed)
        }
        
        private func increaseSpeed() {
            let newSpeed = min(currentSpeed + speedStep, maxSpeed)
            updateSpeed(newSpeed)
        }
        
        private func selectSpeed(_ speed: Double) {
            updateSpeed(speed)
        }
        
        private func updateSpeed(_ newSpeed: Double) {
            currentSpeed = newSpeed
            onSpeedChanged(newSpeed)
        }
    }
    
    struct SpeedButton: View {
        let speed: Double
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: {
                playHapticFeedback()
                action()
            }) {
                Text(String(format: "%.1fx", speed))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: 60, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                    )
            }
        }
    }
    
    struct CustomVerticalSlider: View {
        @Binding var value: Double
        let range: ClosedRange<Double>
        let step: Double
        let onValueChanged: (Double) -> Void
        
        @State private var isDragging = false
        @State private var lastHapticValue: Double = 0
        
        private let sliderHeight: CGFloat = 200
        private let thumbSize: CGFloat = 24
        private let trackWidth: CGFloat = 6
        
        var body: some View {
            VStack(spacing: 12) {
                // Top label (4.0x)
                Text(String(format: "%.1fx", range.upperBound))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                
                // Slider track
                ZStack(alignment: .top) {
                    // Background track (gray) - full height
                    RoundedRectangle(cornerRadius: trackWidth/2)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: trackWidth, height: sliderHeight)
                    
                    // Active track (blue) - from bottom to current position
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: trackWidth/2)
                            .fill(Color.blue)
                            .frame(width: trackWidth, height: activeTrackHeight)
                    }
                    .frame(height: sliderHeight)
                    
                    // Thumb
                    Circle()
                        .fill(Color.blue)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                        .offset(y: thumbOffset)
                        .scaleEffect(isDragging ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: isDragging)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if !isDragging {
                                        isDragging = true
                                    }
                                    
                                    // Calculate new value based on drag position
                                    // Bottom of slider = 0.5x, Top of slider = 4.0x
                                    let dragY = gesture.location.y
                                    let normalizedY = max(0, min(sliderHeight, dragY))
                                    let progress = 1 - (normalizedY / sliderHeight) // 0 at bottom, 1 at top
                                    let newValue = range.lowerBound + progress * (range.upperBound - range.lowerBound)
                                    
                                    // Apply step and clamp
                                    let steppedValue = round(newValue / step) * step
                                    let clampedValue = max(range.lowerBound, min(range.upperBound, steppedValue))
                                    
                                    // Update value if changed
                                    if abs(clampedValue - value) > 0.05 { // Threshold to avoid constant updates
                                        value = clampedValue
                                        onValueChanged(clampedValue)
                                        
                                        // Haptic feedback for significant changes
                                        if abs(clampedValue - lastHapticValue) >= 0.1 {
                                            playHapticFeedback()
                                            lastHapticValue = clampedValue
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                }
                
                // Bottom label (0.5x)
                Text(String(format: "%.1fx", range.lowerBound))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
            }
        }
        
        private var activeTrackHeight: CGFloat {
            // Calculate progress from 0.5x to 4.0x
            let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            return sliderHeight * progress
        }
        
        private var thumbOffset: CGFloat {
            // Calculate thumb position from 0.5x to 4.0x
            let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            return sliderHeight * (1 - progress) - thumbSize/2
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

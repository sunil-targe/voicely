import Foundation
import MediaPlayer
import AVFoundation

class MediaPlayerManager: ObservableObject {
    static let shared = MediaPlayerManager()
    
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var currentSoundscape: SoundscapesView.SoundscapeType = .mute
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var nowPlayingInfo: [String: Any] = [:]
    private var soundscapePlayer: AVPlayer?
    private var soundscapeLoopObserver: Any?
    
    private init() {
        setupRemoteCommandCenter()
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Play command
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }
        
        // Pause command
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        
        // Skip forward command
        commandCenter.skipForwardCommand.preferredIntervals = [15]
        commandCenter.skipForwardCommand.addTarget { [weak self] event in
            if let skipEvent = event as? MPSkipIntervalCommandEvent {
                self?.skipForward(by: skipEvent.interval)
            }
            return .success
        }
        
        // Skip backward command
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
        commandCenter.skipBackwardCommand.addTarget { [weak self] event in
            if let skipEvent = event as? MPSkipIntervalCommandEvent {
                self?.skipBackward(by: skipEvent.interval)
            }
            return .success
        }
        
        // Seek command
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            if let seekEvent = event as? MPChangePlaybackPositionCommandEvent {
                self?.seek(to: seekEvent.positionTime)
            }
            return .success
        }
    }
    
    func configurePlayer(_ player: AVPlayer, title: String, voiceName: String) {
        self.player = player
        
        // Ensure soundscape continues playing when story audio starts
        // The soundscape player should remain active alongside the story player
        
        // Set up time observer
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
            self?.updateNowPlayingInfo()
        }
        
        // Initial setup of now playing info
        setupNowPlayingInfo(title: title, voiceName: voiceName)
    }
    
    private func setupNowPlayingInfo(title: String, voiceName: String) {
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = voiceName
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "Voicely"
        
        // Set default artwork (you can add custom artwork here)
        if let image = UIImage(named: "voicely_icon") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
        }
        
        updateNowPlayingInfo()
    }
    
    private func updateNowPlayingInfo() {
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func play() {
        player?.play()
        isPlaying = true
        updateNowPlayingInfo()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        updateNowPlayingInfo()
    }
    
    func skipForward(by interval: TimeInterval) {
        let newTime = min(currentTime + interval, duration)
        seek(to: newTime)
    }
    
    func skipBackward(by interval: TimeInterval) {
        let newTime = max(currentTime - interval, 0)
        seek(to: newTime)
    }
    
    func seek(to time: TimeInterval) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 600))
        currentTime = time
        updateNowPlayingInfo()
    }
    
    func updateDuration(_ duration: Double) {
        self.duration = duration
        updateNowPlayingInfo()
    }
    
    func cleanup() {
        // Stop the player if it's playing
        player?.pause()
        
        // Remove time observer
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        // Clear now playing info
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        
        // Reset state
        isPlaying = false
        currentTime = 0
        duration = 0
        
        // Clear player reference
        player = nil
        
        // Note: We don't stop the soundscape here to allow it to continue playing
        // The soundscape will continue in the background
    }
    
    // MARK: - Soundscape Management
    
    func playSoundscape(_ soundscape: SoundscapesView.SoundscapeType) {
        // Always stop any currently playing soundscape first
        stopCurrentSoundscape()
        
        // Don't play anything for mute
        if soundscape == .mute {
            currentSoundscape = .mute
            print("MediaPlayerManager: Stopped all soundscapes")
            return
        }
        
        // Configure audio session for soundscape playback
        AudioSessionManager.shared.configureAudioSessionForSoundscape()
        
        // Get the audio file name based on soundscape type
        let fileName = getSoundscapeFileName(for: soundscape)
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("MediaPlayerManager: Could not find audio file for \(soundscape): \(fileName).mp3")
            return
        }
        
        // Create new soundscape player
        let player = AVPlayer(url: url)
        soundscapePlayer = player
        currentSoundscape = soundscape
        
        // Set up looping for soundscape
        soundscapeLoopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            // Only loop if this is still the current soundscape player
            if self?.soundscapePlayer === player {
                player.seek(to: .zero)
                player.play()
            }
        }
        
        // Set appropriate volume for background soundscape
        player.volume = 0.3 // Lower volume for background soundscape
        
        // Start playing
        player.play()
        
        print("MediaPlayerManager: Playing soundscape: \(soundscape) - \(fileName).mp3")
    }
    
    func stopCurrentSoundscape() {
        // Stop current soundscape if playing
        if let player = soundscapePlayer {
            player.pause()
            player.replaceCurrentItem(with: nil)
        }
        
        // Remove soundscape loop observer
        if let observer = soundscapeLoopObserver {
            NotificationCenter.default.removeObserver(observer)
            soundscapeLoopObserver = nil
        }
        
        // Clear current soundscape player
        soundscapePlayer = nil
    }
    
    func stopStoryAudioOnly() {
        // Stop only the story player, keep soundscape playing
        cleanup()
        print("MediaPlayerManager: Stopped story audio only, soundscape continues")
    }
    
    func adjustSoundscapeVolumeForStoryPlayback() {
        // Adjust soundscape volume when story is playing
        if let player = soundscapePlayer {
            player.volume = 0.2 // Even lower volume when story is playing
        }
    }
    
    func restoreSoundscapeVolume() {
        // Restore normal soundscape volume when story stops
        if let player = soundscapePlayer {
            player.volume = 0.3 // Normal background volume
        }
    }
    
    private func getSoundscapeFileName(for soundscape: SoundscapesView.SoundscapeType) -> String {
        switch soundscape {
        case .mute:
            return ""
        case .nature:
            return "nature"
        case .water:
            return "water"
        case .music:
            return "brown"
        case .coffee:
            return "coffee"
        case .fire:
            return "fire"
        case .sparkle:
            return "sparkle"
        case .clock:
            return "clock"
        }
    }
} 

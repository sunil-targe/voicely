import Foundation
import MediaPlayer
import AVFoundation

class MediaPlayerManager: ObservableObject {
    static let shared = MediaPlayerManager()
    
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var nowPlayingInfo: [String: Any] = [:]
    
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
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        player = nil
    }
} 

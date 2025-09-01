import SwiftUI
import DesignSystem
import AVFoundation

struct PlayerHeaderView: View {
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

struct PlayerProgressView: View {
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

struct PlayerControlsView: View {
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

import ActivityKit
import WidgetKit
import SwiftUI
import AVFoundation

@available(iOS 16.1, *)
struct VoicelyLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: VoicelyActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.attributes.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    Text(context.attributes.voiceName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    // Toggle play/pause
                }) {
                    Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .padding()
            .background(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.attributes.title)
                            .font(.headline)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        Text(context.attributes.voiceName)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Button(action: {
                        // Toggle play/pause
                    }) {
                        Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        // Progress bar
                        ProgressView(value: context.state.currentTime, total: context.state.duration)
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        
                        HStack {
                            Text(formatTime(context.state.currentTime))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(formatTime(context.state.duration))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Control buttons
                        HStack(spacing: 20) {
                            Button(action: {
                                // Skip backward
                            }) {
                                Image(systemName: "gobackward.15")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                            
                            Button(action: {
                                // Toggle play/pause
                            }) {
                                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            
                            Button(action: {
                                // Skip forward
                            }) {
                                Image(systemName: "goforward.15")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } compactLeading: {
                // Compact leading
                Image(systemName: context.state.isPlaying ? "waveform" : "waveform.slash")
                    .foregroundColor(.white)
            } compactTrailing: {
                // Compact trailing
                Text(formatTime(context.state.currentTime))
                    .font(.caption2)
                    .foregroundColor(.white)
            } minimal: {
                // Minimal
                Image(systemName: context.state.isPlaying ? "play.fill" : "pause.fill")
                    .foregroundColor(.white)
            }
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let intSec = Int(seconds)
        let min = intSec / 60
        let sec = intSec % 60
        return String(format: "%d:%02d", min, sec)
    }
}

@available(iOS 16.2, *)
struct VoicelyLiveActivity_Previews: PreviewProvider {
    static let attributes = VoicelyActivityAttributes(title: "Sample text for voice generation", voiceName: "Calm Woman")
    static let contentState = VoicelyActivityAttributes.ContentState(isPlaying: true, currentTime: 30, duration: 120)
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
    }
} 

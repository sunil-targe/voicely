import Foundation
import ActivityKit
import AVFoundation

@available(iOS 16.1, *)
struct VoicelyActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isPlaying: Bool
        var currentTime: Double
        var duration: Double
    }
    
    var title: String
    var voiceName: String
}

@available(iOS 16.1, *)
class DynamicIslandManager: ObservableObject {
    static let shared = DynamicIslandManager()
    
    private var activity: Activity<VoicelyActivityAttributes>?
    
    private init() {}
    
    func startActivity(title: String, voiceName: String, isPlaying: Bool, currentTime: Double, duration: Double) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Activities not enabled")
            return
        }
        
        let attributes = VoicelyActivityAttributes(title: title, voiceName: voiceName)
        let contentState = VoicelyActivityAttributes.ContentState(
            isPlaying: isPlaying,
            currentTime: currentTime,
            duration: duration
        )
        
        do {
            activity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            print("Dynamic Island activity started")
        } catch {
            print("Failed to start Dynamic Island activity: \(error)")
        }
    }
    
    func updateActivity(isPlaying: Bool, currentTime: Double, duration: Double) {
        guard let activity = activity else { return }
        
        let contentState = VoicelyActivityAttributes.ContentState(
            isPlaying: isPlaying,
            currentTime: currentTime,
            duration: duration
        )
        
        Task {
            await activity.update(using: contentState)
        }
    }
    
    func endActivity() {
        guard let activity = activity else { return }
        
        Task {
            await activity.end(dismissalPolicy: .immediate)
        }
        
        self.activity = nil
    }
} 
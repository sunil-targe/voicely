import Foundation
import SwiftUI

/// Manages playback speed persistence using UserDefaults
class PlaybackSpeedManager: ObservableObject {
    @Published var currentSpeed: Double = 1.0
    
    private let speedKey = "playback_speed"
    private let defaultSpeed: Double = 1.0
    private let minSpeed: Double = 0.5
    private let maxSpeed: Double = 4.0
    
    init() {
        loadSpeed()
    }
    
    /// Loads the saved playback speed from UserDefaults
    private func loadSpeed() {
        let savedSpeed = UserDefaults.standard.double(forKey: speedKey)
        
        // Validate the saved speed is within bounds
        if savedSpeed >= minSpeed && savedSpeed <= maxSpeed {
            currentSpeed = savedSpeed
        } else {
            currentSpeed = defaultSpeed
        }
        
        print("PlaybackSpeedManager: Loaded speed \(currentSpeed)x from UserDefaults")
    }
    
    /// Saves the current playback speed to UserDefaults
    func saveSpeed(_ speed: Double) {
        // Validate speed is within bounds
        let clampedSpeed = max(minSpeed, min(maxSpeed, speed))
        
        UserDefaults.standard.set(clampedSpeed, forKey: speedKey)
        currentSpeed = clampedSpeed
        
        print("PlaybackSpeedManager: Saved speed \(clampedSpeed)x to UserDefaults")
    }
    
    /// Updates the speed and saves it
    func updateSpeed(_ speed: Double) {
        saveSpeed(speed)
    }
    
    /// Gets the current saved speed
    func getCurrentSpeed() -> Double {
        return currentSpeed
    }
    
    /// Resets speed to default
    func resetToDefault() {
        saveSpeed(defaultSpeed)
    }
}

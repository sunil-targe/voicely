import Foundation
import StoreKit

class RatingPromptManager {
    static let shared = RatingPromptManager()
    private let lastPromptDateKey = "lastRatingPromptDate"
    private let promptCountKey = "ratingPromptCount"
    private let minDaysBetweenPrompts = 7
    private let minEventsBetweenPrompts = 3

    private init() {}

    func requestReviewIfAppropriate() {
        let now = Date()
        let defaults = UserDefaults.standard
        let lastPromptDate = defaults.object(forKey: lastPromptDateKey) as? Date ?? .distantPast
        let promptCount = defaults.integer(forKey: promptCountKey)

        let daysSinceLastPrompt = Calendar.current.dateComponents([.day], from: lastPromptDate, to: now).day ?? 0

        if daysSinceLastPrompt < minDaysBetweenPrompts && promptCount > 0 {
            return // Too soon
        }

        // Increment event count
        let newPromptCount = promptCount + 1
        defaults.set(newPromptCount, forKey: promptCountKey)

        if newPromptCount % minEventsBetweenPrompts == 0 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                defaults.set(now, forKey: lastPromptDateKey)
            }
        }
    }

    // Optionally, reset for testing
    func resetPromptHistory() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: lastPromptDateKey)
        defaults.removeObject(forKey: promptCountKey)
    }
} 

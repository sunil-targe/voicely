import Foundation

struct HistoryStorage {
    static let filename = "history.json"

    static var fileURL: URL {
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(filename)
    }

    static func save(_ history: [HistoryItem]) {
        do {
            let data = try JSONEncoder().encode(history)
            // Use .atomic for all platforms, add .completeFileProtection if available
            #if os(iOS)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            #else
            try data.write(to: fileURL, options: .atomic)
            #endif
        } catch {
            print("Failed to save history: \(error)")
        }
    }

    static func load() -> [HistoryItem] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([HistoryItem].self, from: data)
        } catch {
            print("Failed to load history: \(error)")
            return []
        }
    }
} 
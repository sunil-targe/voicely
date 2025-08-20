import Foundation
import Combine

class FavoritesManager: ObservableObject {
    @Published private(set) var favoriteStoryIDs: Set<Int>
    private let favoritesKey = "favoriteStoryIDs"

    init() {
        let stored = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        self.favoriteStoryIDs = Set(stored)
    }

    func isFavorite(_ storyID: Int) -> Bool {
        favoriteStoryIDs.contains(storyID)
    }

    func toggleFavorite(_ storyID: Int) {
        if favoriteStoryIDs.contains(storyID) {
            favoriteStoryIDs.remove(storyID)
        } else {
            favoriteStoryIDs.insert(storyID)
        }
        save()
    }

    func add(_ storyID: Int) {
        guard !favoriteStoryIDs.contains(storyID) else { return }
        favoriteStoryIDs.insert(storyID)
        save()
    }

    func remove(_ storyID: Int) {
        guard favoriteStoryIDs.contains(storyID) else { return }
        favoriteStoryIDs.remove(storyID)
        save()
    }

    private func save() {
        let array = Array(favoriteStoryIDs)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }
}



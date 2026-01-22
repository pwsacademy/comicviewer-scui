import Foundation
import Logging
import SwiftCrossUI

/// An observable model that stores the set of favorite comics.
class FavoritesStore: SwiftCrossUI.ObservableObject {
    
    /// The current set of favorite comics.
    @SwiftCrossUI.Published
    private(set) var favorites: Set<FavoritesEntry>
    
    /// The currently selected entry in the sidebar.
    @SwiftCrossUI.Published
    var selectedFavorite: FavoritesEntry?
    
    /// Returns `true` if the favorites should be stored in memory only.
    ///
    /// This property disables persistence, which can be useful for testing.
    private var inMemoryOnly: Bool
    
    /// Creates a `FavoritesStore` that loads favorites from a file in the app's settings directory.
    ///
    /// These favorites will be saved automatically every time an entry is added or removed.
    convenience init() {
        self.init(inMemoryOnly: false)
    }
    
    /// Creates a `FavoritesStore`.
    ///
    /// - Parameter inMemoryOnly: When set to `true`, the favorites will not be persisted.
    ///   This is used to implement ``FavoritesStore/example()``.
    private init(inMemoryOnly: Bool) {
        self.inMemoryOnly = inMemoryOnly
        self.favorites = []
        if !inMemoryOnly {
            loadFavorites()
        }
    }
    
    /// Returns `true` if the set of favorites contains the given comic.
    func contains(_ comic: Comic?) -> Bool {
        if let comic {
            favorites.contains(.entry(for: comic))
        } else {
            false
        }
    }
    
    /// Adds the given comic to the set of favorites.
    func add(_ comic: Comic) {
        favorites.insert(.entry(for: comic))
        if !inMemoryOnly {
            saveFavorites()
        }
    }
    
    /// Removes the given comic from the set of favorites.
    func remove(_ comic: Comic) {
        favorites.remove(.entry(for: comic))
        if !inMemoryOnly {
            saveFavorites()
        }
    }

    /// The file in the app's settings directory that stores the persisted favorites.
    private let fileURL = AppSettings.directory.appending(path: "favorites.json")
    
    /// Loads the favorites from a file in the app's settings directory.
    private func loadFavorites() {
        do {
            let data = try Data(contentsOf: fileURL)
            favorites = try JSONDecoder().decode(Set<FavoritesEntry>.self, from: data)
        } catch {
            logger.warning("Failed to load favorites.", metadata: [
                "url": "\(fileURL)"
            ])
        }
    }
    
    /// Stores the favorites in a file in the app's settings directory.
    private func saveFavorites() {
        do {
            try FileManager.default.createDirectoryIfNotExists(AppSettings.directory)
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            logger.error("Failed to save favorites", metadata: [
                "url": "\(fileURL)"
            ])
        }
    }
}

extension FavoritesStore {
    
    /// Returns a `FavoritesStore` that stores its data in memory only.
    /// 
    /// This can be useful for testing.
    static func example() -> FavoritesStore {
        let store = FavoritesStore(inMemoryOnly: true)
        let repository = ExampleComicRepository()
        store.add(repository.fetchComic(1))
        store.add(repository.fetchComic(3))
        return store
    }
}

import SwiftCrossUI

/// Wrapper for objects that would normally be available as a `FocusedValue`.
class FocusedValues: ObservableObject {

    @Published var comicStore: ComicStore?
    @Published var favoritesStore: FavoritesStore?
}

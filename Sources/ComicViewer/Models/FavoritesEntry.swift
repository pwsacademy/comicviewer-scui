import Foundation

/// An entry in the ``FavoritesStore``.
///
/// We don't reuse ``Comic`` for this because the codable representation of that type is tied to the XKCD API.
/// Instead, we use a simpler type with less properties and a straight-forward codable representation.
struct FavoritesEntry: Codable, Hashable {
    
    /// The comic's serial number.
    ///
    /// This number serves as a unique identifier for the comic.
    let number: Int
    
    /// The comic's title.
    let title: String
    
    /// The comic's publication date.
    let date: Date
    
    /// Returns an entry for the given comic.
    static func entry(for comic: Comic) -> FavoritesEntry {
        .init(number: comic.number, title: comic.title, date: comic.date)
    }
}


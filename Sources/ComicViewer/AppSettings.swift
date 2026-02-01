import Foundation

// Keys for storing settings in UserDefaults.
// These are currently unused.
extension String {
    
    static let initialSelectionKey = "initialSelection"
    static let sortFavoritesAscendingKey = "sortFavoritesAscending"
}

/// Various types and properties related to application settings.
enum AppSettings {
    
    /// The initially selected comic.
    enum InitialSelection: String, CaseIterable, RawRepresentable {
        
        /// Shows the most recent comic.
        case latest
        
        /// Shows a random comic.
        case random
        
        /// A description to show when picking a setting.
        var description: String {
            switch self {
            case .latest:
                "latest comic"
            case .random:
                "random comic"
            }
        }
        
        /// A default value for consistency throughout the application.
        static var `default`: Self {
            .latest
        }
    }

    /// The directory where the app saves its settings.
    ///
    /// This currently only applies to favorites.
    /// `UserDefaults` (`@AppStorage`) has its own backing store.
    #if os(Linux)
    static let directory = URL.homeDirectory.appending(
        path: ".config/comic-viewer"
    )
    #elseif os(Windows)
    static let directory = URL.homeDirectory.appending(
        path: "AppData/Local/ComicViewer"
    )
    #else
    static let directory = URL.homeDirectory.appending(
        path: "Library/Application Support/Comic Viewer"
    )
    #endif
}

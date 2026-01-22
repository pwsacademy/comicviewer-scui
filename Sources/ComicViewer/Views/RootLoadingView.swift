import Foundation
import Logging
import SwiftCrossUI

/// View that shows a placeholder (or error) while the comic store is loading.
///
/// This step simplifies the rest of the application.
/// Child views can safely assume the comic store has been initialized.
struct RootLoadingView: View {
    
    @State private var comicStore: ComicStore?
    @State private var favoritesStore = FavoritesStore()
    @State private var loadingFailed = false
    
    private var focusedValues: FocusedValues

    init(_ focusedValues: FocusedValues) {
        self.focusedValues = focusedValues
    }

    var body: some View {
        Group {
            if let comicStore {
                RootView(comicStore, favoritesStore)
            } else if loadingFailed {
                ContentUnavailableView(
                    "Error",
                    icon: "⚠️",
                    description: "The application failed to connect to the server."
                )
            } else {
                ContentUnavailableView(
                    "Loading",
                    icon: "🌐",
                    description: "Please wait while we load a comic for you..."
                )
            }
        }
        .task {
            do {
                // Simulate a slow connection to test the loading screen.
                // try? await Task.sleep(for: .seconds(2))
                comicStore = try await ComicStore(
                    initialSelection: .random,
                    repository: OnlineComicRepository()
                )
                focusedValues.comicStore = comicStore
                focusedValues.favoritesStore = favoritesStore
            } catch {
                logger.critical("Failed to create a comic store.", metadata: [
                    "error": "\(error)"
                ])
                loadingFailed = true
            }
        }
    }
}

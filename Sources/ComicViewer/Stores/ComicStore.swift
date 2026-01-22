import ImageFormats
import Logging
import SwiftCrossUI

/// The main observable model that stores the currently selected comic, its image, and its zoom level.
class ComicStore: ObservableObject {

    private let repository: any ComicRepository
    
    /// Creates a `ComicStore` that fetches its comics from XKCD.
    init(
        initialSelection: AppSettings.InitialSelection,
        repository: OnlineComicRepository,
    ) async throws {
        self.repository = repository
        self.lastComicNumber = try await repository.fetchLatestComicNumber()
        switch initialSelection {
        case .latest:
            await loadComic(lastComicNumber)
        case .random:
            let random = (1...lastComicNumber).randomElement()!
            await loadComic(random)
        }
    }
    
    /// Creates a `ComicStore` that fetches its comics from local files.
    ///
    /// This private initializer is used to implement ``ComicStore/example(initialSelection:)``.
    private init(
        initialSelection: AppSettings.InitialSelection,
        repository: ExampleComicRepository,
    ) {
        self.repository = repository
        self.lastComicNumber = repository.fetchLatestComicNumber()
        switch initialSelection {
        case .latest:
            selectedComic = repository.fetchComic(lastComicNumber)
            imageForSelectedComic = repository.fetchImage(for: selectedComic!)
        case .random:
            let random = (1...lastComicNumber).randomElement()!
            selectedComic = repository.fetchComic(random)
            imageForSelectedComic = repository.fetchImage(for: selectedComic!)
        }
    }
    
    // MARK: - Alerts and sheets
    
    /// Returns `true` if the app is showing the sheet to select a specific comic.
    @Published var isShowingGoToSheet = false
    
    /// Returns `true` if the app is showing an error alert.
    @Published var isShowingError = false
    
    /// The message to show in the error alert.
    @Published var errorMessage: String?
    
    // MARK: - Selection and navigation
    
    /// The serial number of the most recently released comic.
    let lastComicNumber: Int
    
    /// The currently selected comic.
    ///
    /// This property is set to `nil` while loading a new comic.
    @Published var selectedComic: Comic?
    
    /// The image for the currently selected comic.
    ///
    /// This property is set to `nil` while loading a new comic.
    @Published var imageForSelectedComic: ImageFormats.Image<RGBA>?
    
    /// Returns `true` if at least one comic was released *before* the selected one.
    ///
    /// This property always returns `false` if `selectComic` is `nil`.
    var hasPrevious: Bool {
        if let selectedComic {
            selectedComic.number > 1
        } else {
            false
        }
    }
    
    /// Returns `true` if at least one comic was released *after* the selected one.
    ///
    /// This property always returns `false` if `selectComic` is `nil`.
    var hasNext: Bool {
        if let selectedComic {
            selectedComic.number < lastComicNumber
        } else {
            false
        }
    }
    
    /// Selects the first comic ever released.
    func selectFirst() async {
        await loadComic(1)
    }
    
    /// Selects the comic that was released before the selected one.
    func selectPrevious() async {
        guard let selectedComic, hasPrevious else {
            logger.warning("Unable to select the previous comic.", metadata: [
                "selectedComic": selectedComic != nil ? "\(selectedComic!.number)" : "nil"
            ])
            return
        }
        await loadComic(selectedComic.number - 1)
    }
    
    /// Selects a random comic.
    func selectRandom() async {
        var random = (1...lastComicNumber).randomElement()!
        while random == selectedComic?.number {
            random = (1...lastComicNumber).randomElement()!
        }
        await loadComic(random)
    }
    
    /// Selects the comic that was released after the selected one.
    func selectNext() async {
        guard let selectedComic, hasNext else {
            logger.warning("Unable to select the next comic.", metadata: [
                "selectedComic": selectedComic != nil ? "\(selectedComic!.number)" : "nil"
            ])
            return
        }
        await loadComic(selectedComic.number + 1)
    }
    
    /// Selects the most recently released comic.
    func selectLast() async {
        await loadComic(lastComicNumber)
    }
    
    /// Selects the comic with the given number.
    func selectSpecific(number: Int) async {
        await loadComic(number)
    }
    
    /// Loads the selected comic and its image.
    ///
    /// Also resets the zoom level.
    private func loadComic(_ number: Int) async {
        precondition((1...lastComicNumber).contains(number))
        // Avoid reloading the selected comic.
        guard selectedComic?.number != number else { return }
        selectedComic = nil
        imageForSelectedComic = nil
        zoomLevel = 1
        do {
            selectedComic = try await repository.fetchComic(number)
            imageForSelectedComic = try await repository.fetchImage(for: selectedComic!)
        } catch {
            logger.error("Failed to load comic.", metadata: [
                "number": "\(number)",
                "error": "\(error)"
            ])
            // Clear the selected comic in case the image failed to load.
            selectedComic = nil
            isShowingError = true
            errorMessage = "Comic \(number) failed to load."
        }
    }
    
    // MARK: - Zooming in and out
    
    /// The current zoom level.
    ///
    /// Images are first scaled using ``/ImageFormats/Image/scaleToFit(availableWidth:availableHeight:minSize:downScaleLimit:upScaleLimit:)``.
    /// This property allows the user to manually adjust the scale of the image.
    @Published var zoomLevel = 1.0
    
    /// Resets the zoom level to 1.
    func zoomActual() {
        zoomLevel = 1
    }
    
    /// Increases the zoom level.
    func zoomIn() {
        zoomLevel += 0.2
    }
    
    /// Decreases the zoom level.
    func zoomOut() {
        zoomLevel -= 0.2
    }
}

extension ComicStore {
    
    /// Returns a `ComicStore` that fetches comics from local files.
    /// 
    /// This can be useful for testing.
    static func example(initialSelection: AppSettings.InitialSelection) -> ComicStore {
        ComicStore(
            initialSelection: initialSelection,
            repository: ExampleComicRepository()
        )
    }
}

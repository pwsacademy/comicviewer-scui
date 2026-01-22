import Foundation
import SwiftCrossUI

/// Menu items to (un)favorite the selected comic, export it, and control the zoom level.
struct ComicCommands {

    private var focusedValues: FocusedValues
    private var openSaveDialog: PresentFileSaveDialogAction

    init(_ focusedValues: FocusedValues, _ openSaveDialog: PresentFileSaveDialogAction) {
        self.focusedValues = focusedValues
        self.openSaveDialog = openSaveDialog
    }

    var body: CommandMenu {
        CommandMenu("Comic") {
            Button("Toggle Favorite") {
                guard let favoritesStore = focusedValues.favoritesStore,
                      let comic = focusedValues.comicStore?.selectedComic else {
                    return
                }
                if favoritesStore.contains(comic) {
                    favoritesStore.remove(comic)
                } else {
                    favoritesStore.add(comic)
                }
            }

            Divider()

            Button("Actual Size") {
                focusedValues.comicStore?.zoomActual()
            }
            Button("Zoom In") {
                focusedValues.comicStore?.zoomIn()
            }
            Button("Zoom Out") {
                focusedValues.comicStore?.zoomOut()
            }

            Divider()
            
            Button("Save…") {
                Task { await save() }
            }
        }
    }

    private func save() async {
        guard let comicStore = focusedValues.comicStore,
              let image = comicStore.imageForSelectedComic else {
            logger.warning("""
                Cancelling save.
                The selection may have changed since the action was started.
                """)
            return
        }
        guard var url = await openSaveDialog() else {
            return
        }
        do {
            url = url.deletingPathExtension().appendingPathExtension("png")
            let data = Data(try image.encode(to: .png))
            try data.write(to: url, options: .atomic)
        } catch {
            logger.error("Failed to save this file.", metadata: [
                "url": "\(url)",
                "error": "\(error)"
            ])
            comicStore.isShowingError = true
            comicStore.errorMessage = "An error occurred while saving this file."
        }
    }
}

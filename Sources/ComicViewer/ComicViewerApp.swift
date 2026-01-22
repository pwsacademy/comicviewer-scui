import DefaultBackend
import SwiftCrossUI

@main
struct ComicViewerApp: App {

    @State private var focusedValues = FocusedValues()

    @Environment(\.chooseFileSaveDestination) private var openSaveDialog
    @Environment(\.openURL) private var openURL

    var body: some Scene {
        WindowGroup("Comic Viewer") {
            RootLoadingView(focusedValues)
        }
        .defaultSize(width: 800, height: 600)
        .commands {
            ComicCommands(focusedValues, openSaveDialog).body
            NavigationCommands(focusedValues).body
            HelpCommands(openURL).body
        }
    }
}

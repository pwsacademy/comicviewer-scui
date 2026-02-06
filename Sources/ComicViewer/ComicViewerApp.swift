import DefaultBackend
import SwiftCrossUI

@main
struct ComicViewerApp: App {

    @State private var focusedValues = FocusedValues()

    @Environment(\.chooseFileSaveDestination) private var openSaveDialog
    @Environment(\.openURL) private var openURL
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        Window("Comic Viewer", id: "comic") {
            RootLoadingView(focusedValues)
        }
        .defaultLaunchBehavior(.presented)
        .defaultSize(width: 800, height: 600)
        .commands {
            ComicCommands(focusedValues, openSaveDialog).body
            NavigationCommands(focusedValues).body
            HelpCommands(openURL, openWindow).body
        }

        Window("About", id: "about") {
            AboutView()
                .preferredWindowMinimizeBehavior(.disabled)
                .windowResizeBehavior(.disabled)
        }
        .windowResizability(.contentSize)
    }
}

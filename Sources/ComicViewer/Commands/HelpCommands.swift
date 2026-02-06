import Foundation
import SwiftCrossUI

/// Menu item to browse the source code.
struct HelpCommands {

    private var openURL: OpenURLAction
    private var openWindow: OpenWindowAction

    init(_ openURL: OpenURLAction, _ openWindow: OpenWindowAction) {
        self.openURL = openURL
        self.openWindow = openWindow
    }

    var body: CommandMenu {
        CommandMenu("Help") {
            Button("About Comic Viewer") {
                openWindow(id: "about")
            }
            Button("Browse Source Code") {
                openURL(URL(string: "https://github.com/pwsacademy/comicviewer-scui/")!)
            }
        }
    }
}

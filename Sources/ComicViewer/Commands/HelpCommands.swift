import Foundation
import SwiftCrossUI

/// Menu item to browse the source code.
struct HelpCommands {

    private var openURL: OpenURLAction

    init(_ openURL: OpenURLAction) {
        self.openURL = openURL
    }

    var body: CommandMenu {
        CommandMenu("Help") {
            Button("Browse Source Code") {
                openURL(URL(string: "https://github.com/pwsacademy/comicviewer-scui/")!)
            }
        }
    }
}

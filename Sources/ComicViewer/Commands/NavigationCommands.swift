import SwiftCrossUI

/// Menu items for navigating to a different comic.
struct NavigationCommands {
    
    private var focusedValues: FocusedValues
    
    init(_ focusedValues: FocusedValues) {
        self.focusedValues = focusedValues
    }

    var body: CommandMenu {
        CommandMenu("Go") {
            Button("First") {
                Task { await focusedValues.comicStore?.selectFirst() }
            }
            Button("Previous") {
                Task { await focusedValues.comicStore?.selectPrevious() }
            }
            Button("Random") {
                Task { await focusedValues.comicStore?.selectRandom() }
            }
            Button("Next") {
                Task { await focusedValues.comicStore?.selectNext() }
            }
            Button("Last") {
                Task { await focusedValues.comicStore?.selectLast() }
            }

            Divider()
            
            Button("Specific Comic…") {
                focusedValues.comicStore?.isShowingGoToSheet = true
            }
        }
    }
}

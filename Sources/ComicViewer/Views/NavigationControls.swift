import SwiftCrossUI

struct NavigationControls: View {
    
    private var comicStore: ComicStore
    
    init(_ comicStore: ComicStore) {
        self.comicStore = comicStore
    }

    var body: some View {
        HStack {
            Button("⏮") {
                Task { await comicStore.selectFirst() }
            }
            .font(.title)
            .disabled(!comicStore.hasPrevious)

            Button("◀") {
                Task { await comicStore.selectPrevious() }
            }
            .font(.title)
            .disabled(!comicStore.hasPrevious)
            
            Button("↻") {
                Task { await comicStore.selectRandom() }
            }
            .font(.title)

            Button("▶") {
                Task { await comicStore.selectNext() }
            }
            .font(.title)
            .disabled(!comicStore.hasNext)

            Button("⏭") {
                Task { await comicStore.selectLast() }
            }
            .font(.title)
            .disabled(!comicStore.hasNext)
        }
    }
}


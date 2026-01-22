import SwiftCrossUI

struct RootView: View {
    
    private var comicStore: ComicStore
    private var favoritesStore: FavoritesStore

    init(_ comicStore: ComicStore, _ favoritesStore: FavoritesStore) {
        self.comicStore = comicStore
        self.favoritesStore = favoritesStore
    }
    
    var body: some View {
        NavigationSplitView {
            FavoritesSidebar(comicStore, favoritesStore)
        } detail: {
            ContentView(comicStore, favoritesStore)
                .padding(20)
        }
    }
}

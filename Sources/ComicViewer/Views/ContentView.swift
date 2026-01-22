import SwiftCrossUI

struct ContentView: View {
    
    private var comicStore: ComicStore
    private var favoritesStore: FavoritesStore

    init(_ comicStore: ComicStore, _ favoritesStore: FavoritesStore) {
        self.comicStore = comicStore
        self.favoritesStore = favoritesStore
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let comic = comicStore.selectedComic,
               let image = comicStore.imageForSelectedComic {
                ZStack(alignment: .topTrailing) {
                    ComicView(comic, image, zoom: comicStore.zoomLevel)
                    favoriteButton
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            NavigationControls(comicStore)
        }
        .alert(
            "Error: \(comicStore.errorMessage ?? "An unknown error occurred.")",
            isPresented: comicStore.$isShowingError
        ) { }
        .sheet(isPresented: comicStore.$isShowingGoToSheet) {
            GoToSheet(comicStore, selectedNumber: comicStore.selectedComic?.number ?? 1)
        }
    }

    private var favoriteButton: some View {
        let isFavorite = favoritesStore.contains(comicStore.selectedComic)
        return Text(isFavorite ? "♥" : "♡")
            .font(.largeTitle)
            .foregroundColor(isFavorite ? .red : .white)
            .onTapGesture {
                if isFavorite {
                    favoritesStore.remove(comicStore.selectedComic!)
                } else if let comic = comicStore.selectedComic {
                    favoritesStore.add(comic)
                }
            }
    }
}

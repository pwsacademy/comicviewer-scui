import SwiftCrossUI

struct FavoritesSidebar: View {
    
    @AppStorage(SortFavoritesAscending.self)
    private var sortFavoritesAscending: Bool

    private var comicStore: ComicStore
    private var favoritesStore: FavoritesStore

    init(_ comicStore: ComicStore, _ favoritesStore: FavoritesStore) {
        self.comicStore = comicStore
        self.favoritesStore = favoritesStore
    }
    
    private var sortedFavorites: [FavoritesEntry] {
        favoritesStore.favorites.sorted {
            if sortFavoritesAscending {
                $0.number < $1.number
            } else {
                $0.number > $1.number
            }
        }
    }
        
    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .trailing) {
                Text("Favorites")
                    .font(.title)
                    .emphasized()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(sortFavoritesAscending ? "↓" : "↑")
                    .font(.title)
                    .onTapGesture {
                        sortFavoritesAscending.toggle()
                    }
            }
            .padding()
            List(sortedFavorites, id: \.self, selection: favoritesStore.$selectedFavorite) {
                favorite in
                VStack(alignment: .leading, spacing: 2) {
                    Text(favorite.title)
                        .font(.headline)
                    Text("#\(formattedNumber(favorite)) - \(formattedDate(favorite))")
                        .foregroundColor(.gray)
                }
                .padding(5)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            // Forward the selection to the comic store.
            .onChange(of: favoritesStore.selectedFavorite) {
                if let newValue = favoritesStore.selectedFavorite {
                    Task { await comicStore.selectSpecific(number: newValue.number) }
                }
            }
            // Clear the selected favorite when a new comic is selected.
            .onChange(of: comicStore.selectedComic) {
                // The selected comic will transition through nil while the comic is loading,
                // so we need to ignore that case here.
                if let newValue = comicStore.selectedComic {
                    if newValue.number != favoritesStore.selectedFavorite?.number {
                        favoritesStore.selectedFavorite = nil
                    }
                }
            }
        }
        .frame(minWidth: 200)
        .padding()
    }
    
    private func formattedNumber(_ entry: FavoritesEntry) -> String {
        entry.number.formatted(.number.grouping(.never))
    }
    
    private func formattedDate(_ entry: FavoritesEntry) -> String {
        entry.date.formatted(date: .abbreviated, time: .omitted)
    }
}

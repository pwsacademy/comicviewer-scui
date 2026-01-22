import Foundation
import ImageFormats

/// A repository that fetches comics from local files.
///
/// This can be useful for testing.
///
/// Use ``ComicStore/example(initialSelection:)`` to create a store that uses this repository.
class ExampleComicRepository: ComicRepository {
    
    private let comics: [Comic]
    
    init() {
        let url = Bundle.module.url(forResource: "examples", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let comics = try! JSONDecoder().decode([Comic].self, from: data)
        self.comics = comics.sorted { $0.number < $1.number }
    }
    
    func fetchLatestComicNumber() -> Int {
        comics.count
    }
    
    func fetchComic(_ number: Int) -> Comic {
        comics[number - 1]
    }
    
    func fetchImage(for comic: Comic) -> Image<RGBA> {
        let fileName = comic.image.lastPathComponent
        let url = Bundle.module.url(forResource: fileName, withExtension: nil)!
        let data = try! Data(contentsOf: url)
        return try! Image<RGBA>.load(from: [UInt8](data))
    }
}

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import ImageFormats

/// A repository that fetches comics from the [XKCD API](https://xkcd.com/json.html).
class OnlineComicRepository: ComicRepository {
        
    func fetchLatestComicNumber() async throws -> Int {
        let (data, _) = try await URLSession.shared.data(
            from: URL(string: "https://xkcd.com/info.0.json")!
        )
        let comic = try JSONDecoder().decode(Comic.self, from: data)
        return comic.number
    }
    
    func fetchComic(_ number: Int) async throws -> Comic {
        let (data, _) = try await URLSession.shared.data(
            from: URL(string: "https://xkcd.com/\(number)/info.0.json")!
        )
        return try JSONDecoder().decode(Comic.self, from: data)
    }
    
    func fetchImage(for comic: Comic) async throws -> Image<RGBA> {
        let (data, _) = try await URLSession.shared.data(from: comic.image)
        guard let image = try? Image<RGBA>.load(from: [UInt8](data)) else {
            throw ComicRepositoryError.invalidImage
        }
        return image
    }
}

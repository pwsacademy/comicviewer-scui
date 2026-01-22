import ImageFormats

/// A repository that can fetch comics from a specified source.
///
/// This is a helper type for ``ComicStore``.
/// Use either ``OnlineComicRepository`` to fetch comics from XKCD,
/// or ``ExampleComicRepository`` for testing purposes.
protocol ComicRepository {
    
    /// Fetch the serial number of the most recently released comic.
    func fetchLatestComicNumber() async throws -> Int
    
    /// Fetch the comic with the given number.
    func fetchComic(_ number: Int) async throws -> Comic
    
    /// Fetch the image for the given comic.
    func fetchImage(for comic: Comic) async throws -> Image<RGBA>
}

enum ComicRepositoryError: Error {
    
    /// The image URL did not return valid image data.
    case invalidImage
}

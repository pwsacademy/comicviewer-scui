import Foundation

// TODO: Do we still need this type when we have ImageFormats.Image?

/// Image data for a ``Comic``.
///
/// This type is nonisolated to allow its unit tests to run in parallel.
/// Otherwise, the default main actor isolation would apply to this type, even though it doesn't require any isolation.
nonisolated struct ComicImage {
    
    /// The bytes for this image.
    let data: Data
    
    /// The original width of the image.
    let width: Double
    
    /// The original height of the image.
    let height: Double
    
    /// Returns an appropriate scale factor to fit this image in the given space.
    ///
    /// - Parameters:
    ///   - availableWidth: The available horizontal space for this image in its parent view.
    ///   - availableHeight: The available vertical space for this image in its parent view.
    ///   - minSize: The minimum width and height for this image.
    ///   The image will scale up to reach this minimum size, regardless of `upScaleLimit`.
    ///   - downScaleLimit: The minimum scale factor allowed when downscaling an image
    ///   that is slightly too large for the available space. An image will never scale below `minSize`.
    ///   - upScaleLimit: The maximum scale factor allowed when upscaling an image that is smaller than the available space.
    func scaleToFit(
        availableWidth: Double,
        availableHeight: Double,
        minSize: Double = 250,
        downScaleLimit: Double = 0.70,
        upScaleLimit: Double = 4
    ) -> Double {
        var scale = 1.0
        // First, scale the image up to its minimum size.
        if width < minSize || height < minSize {
            scale = max(minSize / width, minSize / height)
        }
        if width * scale > availableWidth || height * scale > availableHeight {
            // If the image is larger than the available size, try to downscale it.
            let downScale = min(
                availableWidth / (width * scale),
                availableHeight / (height * scale)
            )
            if downScale >= downScaleLimit &&
               width * scale * downScale >= minSize &&
               height * scale * downScale >= minSize {
                scale *= downScale
            }
        } else {
            // If the image is smaller than the available size, try to upscale it.
            let upScale = min(
                availableWidth / (width * scale),
                availableHeight / (height * scale)
            )
            scale *= upScale
            if scale > upScaleLimit {
                scale = upScaleLimit
            }
        }
        return scale
    }
}

extension ComicImage {
    
    /// Returns a `ComicImage` loaded from a local file.
    ///
    /// This can be useful for testing.
    static func example() -> ComicImage {
        let data = try! Data(contentsOf: Bundle.module.url(forResource: "compiling", withExtension: "png")!)
        return ComicImage(data: data, width: 413, height: 360)
    }
}

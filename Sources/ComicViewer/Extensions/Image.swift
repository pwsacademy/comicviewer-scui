import ImageFormats

extension Image {

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
        let width = Double(width)
        let height = Double(height)
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
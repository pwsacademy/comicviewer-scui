import ImageFormats
import SwiftCrossUI

struct ComicView: View {
        
    private let comic: Comic
    private let image: ImageFormats.Image<RGBA>
    private let zoom: Double
    
    init(_ comic: Comic, _ image: ImageFormats.Image<RGBA>, zoom: Double = 1.0) {
        self.comic = comic
        self.image = image
        self.zoom = zoom
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 0) {
                Text(comic.title)
                    .font(.title)
                Text("#\(number) - \(date)")
                    .foregroundColor(.gray)
            }
            GeometryReader { proxy in
                let scale = image.scaleToFit(
                    availableWidth: proxy.size.width,
                    availableHeight: proxy.size.height
                ) * zoom
                ZStack(alignment: .center) {
                    Image(image)
                        .resizable()
                        .frame(
                            width: Int(Double(image.width) * scale),
                            height: Int(Double(image.height) * scale)
                        )
                }
                .frame(
                    width: toInt(proxy.size.width),
                    height: toInt(proxy.size.height),
                    alignment: .center
                )
            }
            Text(comic.description)
                .frame(maxWidth: 600)
        }
    }
    
    private var number: String {
        comic.number.formatted(.number.grouping(.never))
    }
    
    private var date: String {
        comic.date.formatted(date: .abbreviated, time: .omitted)
    }

    /// Temporary workaround because SwiftCrossUI still uses integers for frame widths and heights.
    private func toInt(_ value: Double) -> Int {
        if value.isInfinite {
            Int.max
        } else {
            Int(value)
        }
    }
}

import SwiftCrossUI

/// Workaround that simulates SwiftUI's `ContentUnavailableView`.
/// 
/// This view uses emojis as icons. It doesn't support images yet.
struct ContentUnavailableView: View {

    var title: String
    var icon: String?
    var description: String?

    init(_ title: String, icon: String? = nil, description: String? = nil) {
        self.title = title
        self.icon = icon
        self.description = description
    }

    var body: some View {
        VStack {
            if let icon {
                Text(icon)
                    .font(.system(size: 40))
            }
            Text(title)
                .font(.title)
            if let description {
                Text(description)
            }
        }
    }
}
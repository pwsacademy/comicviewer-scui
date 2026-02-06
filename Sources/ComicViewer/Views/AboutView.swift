import SwiftCrossUI

struct AboutView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            VStack(alignment: .leading) {
                Text("Comic Viewer")
                    .font(.largeTitle)
                Text("by PWS Academy")
                    .font(.title3)
            }
            Text("""
                This app is open source and made for educational purposes only.
                All content is provided by XKCD under the CC BY-NC 2.5 license.
                """)
                .foregroundColor(.gray)
        }
        .padding(20)
    }
}

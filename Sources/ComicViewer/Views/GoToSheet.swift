import SwiftCrossUI

struct GoToSheet: View {
    
    @Environment(\.dismiss) private var dismiss    
    @State private var input: String
    
    private var comicStore: ComicStore
    
    init(_ comicStore: ComicStore, selectedNumber: Int) {
        self.comicStore = comicStore
        self.input = "\(selectedNumber)"
    }

    private var isValid: Bool {
        guard let number = Int(input) else {
            return false
        }
        return (1...comicStore.lastComicNumber).contains(number)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Which comic would you like to see?")
                .font(.headline)
            TextField(input, text: $input)
            if !isValid {
                Text("Please enter a number between 1 and \(comicStore.lastComicNumber)")
                    .foregroundColor(.red)
                    .font(.callout)
                    .emphasized()
            }
            HStack(spacing: 10) {
                Button("Cancel") {
                    dismiss()
                }
                Button("Go") {
                    Task { await comicStore.selectSpecific(number: Int(input)!) }
                    dismiss()
                }
                .disabled(!isValid)
            }
        }
        .frame(minWidth: 250, minHeight: 100, alignment: .top)
        .padding(20)
    }
}

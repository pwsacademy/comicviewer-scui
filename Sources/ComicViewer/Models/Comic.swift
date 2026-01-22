import Foundation

/// A comic.
///
/// This type holds most of the fields provided by the [XKCD API](https://xkcd.com/json.html) .
struct Comic: Equatable {

    /// The comic's serial number.
    ///
    /// This number serves as a unique identifier for the comic.
    let number: Int
    
    /// The comic's title.
    let title: String
    
    /// The comic's publication date.
    let date: Date
    
    /// A URL pointing to the comic's image file..
    let image: URL
    
    /// The comic's description (alt text).
    let description: String
}

extension Comic: Decodable {

    /// Decoding keys that match the format used by the XKCD API .
    enum DecodingKeys: String, CodingKey {
        case number = "num"
        case title
        case day
        case month
        case year
        case image = "img"
        case description = "alt"
    }

    /// Decode a comic from the XKCD API.
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        let number = try values.decode(Int.self, forKey: .number)
        let title = try values.decode(String.self, forKey: .title)
        let day = try values.decode(String.self, forKey: .day)
        let month = try values.decode(String.self, forKey: .month)
        let year = try values.decode(String.self, forKey: .year)
        let imageURL = try values.decode(String.self, forKey: .image)
        let description = try values.decode(String.self, forKey: .description)

        // Check if day, month, and year are strings that contain an integer.
        guard let day = Int(day) else {
            throw DecodingError.typeMismatch(
                String.self,
                .init(
                    codingPath: [DecodingKeys.day],
                    debugDescription: "string 'day' must contain an integer"
                )
            )
        } 
        guard let month = Int(month) else {
            throw DecodingError.typeMismatch(
                String.self,
                .init(
                    codingPath: [DecodingKeys.month],
                    debugDescription: "string 'month' must contain an integer"
                )
            )
        } 
        guard let year = Int(year) else {
            throw DecodingError.typeMismatch(
                String.self,
                .init(
                    codingPath: [DecodingKeys.year],
                    debugDescription: "string 'year' must contain an integer"
                )
            )
        }
        // Check if day, month, and year form a valid date.
        let components = DateComponents(
            calendar: .current,
            timeZone: .init(identifier: "UTC"),
            year: year,
            month: month,
            day: day
        )
        guard components.isValidDate, let date = components.date else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: [DecodingKeys.day, .month, .year],
                    debugDescription: "values 'day', 'month', and 'year' must form a valid date"
                )
            )
        }
        // Check if the image URL is valid.
        guard let image = URL(string: imageURL) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: [DecodingKeys.image],
                    debugDescription: "string 'img' must contain a valid URL"
                )
            )
        }
        self.number = number
        self.title = title
        self.date = date
        self.image = image
        self.description = description
    }
}

extension Comic {

    /// Returns a `Comic` loaded from a local file.
    /// 
    /// This can be useful for testing.
    static func example() -> Comic {
        let data = try! Data(contentsOf: Bundle.module.url(forResource: "example", withExtension: "json")!)
        return try! JSONDecoder().decode(Comic.self, from: data)
    }
}

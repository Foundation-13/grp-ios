import Foundation

struct Review: Codable {
    let id: Int
    let creator: Int
    let location: Places.Place
    let text: String
    let stars: Int
}

extension Review: JSONCodable {}

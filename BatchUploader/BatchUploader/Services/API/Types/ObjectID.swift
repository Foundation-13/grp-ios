import Foundation

struct ObjectID: Codable {
    let id: Int
}

extension ObjectID: JSONCodable {}

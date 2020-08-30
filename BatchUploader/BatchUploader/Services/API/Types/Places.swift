import Foundation

struct Point: Codable {
    let latitude: Double
    let longitude: Double
}

struct PointWithID: Codable {
    let id: String?
    let point: Point
}

enum Places {
    
    struct SearchByPointsReq: Codable  {
        let points: [PointWithID]
    }
    
    struct Place: Codable {
        let id: Int?
        let externalID: String?
        let placeType: Int
        let title: String
        let tags: [String]
        let vicinity: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case externalID = "external_id"
            case placeType = "place_type"
            case title = "title"
            case tags = "tags"
            case vicinity = "vicinity"
        }
    }
    
    struct PlaceWithDistance: Codable {
        let place: Place
        let distance: Int
        
        enum CodingKeys: String, CodingKey {
            case place
            case distance
        }
    }
    
    struct Cluster: Codable {
        let pointIDs: [String]
        let center: Point
        let places: [PlaceWithDistance]
        let withError: Bool
        
        enum CodingKeys: String, CodingKey {
            case pointIDs = "point_ids"
            case center
            case places
            case withError = "with_error"
        }
    }
    
    struct SearchByPointsResult: Codable {
        let clusters: [Cluster]
    }
}

extension Places.SearchByPointsReq: JSONEncodable {}

extension Places.SearchByPointsResult: JSONDecodable {}

extension Places.Place {
    static func make(id: Int? = nil, externalID: String? = nil, placeType: Int = 0, title: String = "", tags: [String] = [], vicinity: String = "") -> Self {
        return Places.Place(id: id, externalID: externalID, placeType: placeType, title: title, tags: tags, vicinity: vicinity)
    }
}

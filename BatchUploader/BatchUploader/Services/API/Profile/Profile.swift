import Foundation

struct UserProfile: Codable {
    private enum Const {
        static let emptyBirthday = Date.make(year: 1800, month: 1, day: 1)!
    }
    
    let id: Int
    let name: String
    let birthDate: Date
    let email: String?
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case birthDate = "birth_date"
        case email = "email"
        case avatar = "avatar"
    }
    
    // MARK:- Properties
    
    /**
     * Return true if profile is empty (must be updated from the client)
     */
    var isEmpty: Bool {
        return id == 0
    }
    
    var avatarUrl: URL? {
        guard let avatar = avatar else {
            return nil
        }
        return URL(string: avatar)
    }
}

// MARK:-
extension UserProfile {
    static func make(id: Int = 0, name: String = "", birthDate: Date = Date(), email: String = "", avatar: String = "") -> UserProfile {
        return UserProfile(id: id, name: name, birthDate: birthDate, email: email, avatar: avatar)
    }
}

// MARK:-
extension UserProfile: JSONCodable {
    static func decode(_ data: Data, decoder: JSONDecoder) throws -> Self {
        decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            if dateStr.isEmpty {
                return Const.emptyBirthday
            }
            
            guard let date = DateFormatter.yyyyMMdd.date(from: dateStr) else {
                throw ServiceError.invalidDate(dateStr)
            }
            
            return date
        }
        
        return try decoder.decode(UserProfile.self, from: data)
    }
    
    func encode(encoder: JSONEncoder) throws -> Data {
        encoder.dateEncodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        return try encoder.encode(self)
    }
    
}




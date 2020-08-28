import Foundation

typealias JSONCodable = JSONDecodable & JSONEncodable

// MARK:- JSONDecodable
protocol JSONDecodable {
    static func decode(_ data: Data?, decoder: JSONDecoder) throws -> Self
    static func decode(_ data: Data, decoder: JSONDecoder) throws -> Self
}

extension JSONDecodable {
    static func decode(_ data: Data?, decoder: JSONDecoder) throws -> Self {
        guard let data = data else {
            throw ServiceError.emptyResponse
        }
        
        return try decode(data, decoder: decoder)
    }
}

// MARK:- JSONEncodable
protocol JSONEncodable {
    func encode(encoder: JSONEncoder) throws -> Data
}

// MARK:- IgnorableResult
struct IgnorableResult {}

extension IgnorableResult: Codable {}

extension IgnorableResult: JSONDecodable {
    static func decode(_ data: Data?, decoder: JSONDecoder) throws -> Self {
        return IgnorableResult()
    }
    
    static func decode(_ data: Data, decoder: JSONDecoder) throws -> Self {
        return IgnorableResult()
    }
}




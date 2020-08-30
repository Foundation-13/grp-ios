import Foundation

typealias JSONCodable = JSONDecodable & JSONEncodable

// MARK:- JSONDecodable
protocol JSONDecodable: Decodable {
    static func decode(_ data: Data?, decoder: JSONDecoder) throws -> Self
    static func decode(_ data: Data, decoder: JSONDecoder) throws -> Self
}

extension JSONDecodable {
    static func decode(_ data: Data, decoder: JSONDecoder) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
    
    static func decode(_ data: Data?, decoder: JSONDecoder) throws -> Self {
        guard let data = data else {
            throw ServiceError.emptyResponse
        }
        
        return try decode(data, decoder: decoder)
    }
}

// MARK:- JSONEncodable
protocol JSONEncodable: Encodable {
    func encode(encoder: JSONEncoder) throws -> Data
}

extension JSONEncodable {
    func encode(encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(self)
    }
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




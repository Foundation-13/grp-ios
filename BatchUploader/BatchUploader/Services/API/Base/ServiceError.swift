import Foundation

enum ServiceError: Error {
    case notImplemented
    case notAuthentificated
    case emptyResponse
    case stringEncoding
    case invalidUrl(String)
    case authError(Error)
    case unexpected(String)
    case decoding(Error)
    case network(Error)
    case other(String)
    case invalidDate(String)
}

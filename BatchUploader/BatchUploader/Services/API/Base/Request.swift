import Foundation
import Alamofire

protocol HostProvider {
    var host: String { get }
}

struct DefaultHostProvider: HostProvider {
    var host: String {
        return "127.0.0.1"
    }
}

enum RequestAuthType {
    case bearer
    case notRequired
}

// MARK:- BaseRequest
class BaseRequest: URLConvertible, URLRequestConvertible  {
    
    init(endpoint: String, method: HTTPMethod, parameters: Parameters = [:], auth: RequestAuthType = .bearer, hostProvider: HostProvider = DefaultHostProvider()) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
        self.auth = auth
        self.hostProvider = hostProvider
    }
    
    let endpoint: String
    let method: HTTPMethod
    let parameters: Parameters
    let auth: RequestAuthType
    let hostProvider: HostProvider
    
    func asURL() throws -> URL {
        guard var components = URLComponents(string: hostProvider.host)  else { throw ServiceError.invalidUrl(hostProvider.host) }
        components.path = endpoint
        return try components.asURL()
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try self.asURL()
        
        if !parameters.isEmpty {
            let encoding = URLEncoding.queryString
            return try encoding.encode(URLRequest(url: url, method: method), with: parameters)
        }
        
        return try URLRequest(url: url, method: method)
    }
}

// MARK:- Request with json encodable body
class JsonRequest<T: JSONEncodable>: BaseRequest {
    init(endpoint: String, method: HTTPMethod, body: T, parameters: Parameters = [:], auth: RequestAuthType = .bearer, hostProvider: HostProvider = DefaultHostProvider()) {
        
        self.body = body
        super.init(endpoint: endpoint, method: method, parameters: parameters, auth: auth, hostProvider: hostProvider)
    }
    
    let body: T
    
    override func asURLRequest() throws -> URLRequest {
        var request = try super.asURLRequest()
        request.httpBody = try body.encode(encoder: JSONEncoder())
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

// MARK:- upload file request
class UploadRequest: BaseRequest {
    init(endpoint: String, method: HTTPMethod, data: Data, name: String, fileName: String? = nil, mimeType: String? = nil, parameters: Parameters = [:], auth: RequestAuthType = .bearer, hostProvider: HostProvider = DefaultHostProvider()) {
        
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        
        super.init(endpoint: endpoint, method: method, parameters: parameters, auth: auth, hostProvider: hostProvider)
    }
    
    let data: Data
    let name: String
    let fileName: String?
    let mimeType: String?
}


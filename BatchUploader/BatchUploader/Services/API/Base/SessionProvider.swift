import Foundation
import Alamofire

protocol AfSessionProvider {
    var authSession: Session { get }
    var rawSession: Session { get }
}

// MARK:-

final class AfSessionProviderImpl: AfSessionProvider {
    init(configuration: URLSessionConfiguration, userSession: UserSession) {
        self.rawSession = Session(configuration: configuration)
        
        let interceptor = Interceptor(userSession: userSession)
        self.authSession = Session(configuration: configuration, interceptor: interceptor)
    }
    
    let authSession: Session
    let rawSession: Session
    
    typealias AdapterResult = Result<URLRequest, Error>
    
    // MARK:-
    private final class Interceptor: RequestInterceptor {
        let userSession: UserSession
        
        init(userSession: UserSession) {
            self.userSession = userSession
        }
        
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AdapterResult) -> Void) {
            userSession.getToken().done { (token) in
                var copy = urlRequest
                copy.addValue(token.bearer, forHTTPHeaderField: "Authorization")
                completion(.success(copy))
            }.catch { (err) in
                completion(.failure(err))
            }
        }
        
        func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
            completion(.doNotRetry)
        }
    }
}


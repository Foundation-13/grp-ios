import Foundation
import Alamofire
import PromiseKit

final class RequestExecutor {
    init(sessionProvider: AfSessionProvider) {
        self.sessionProvider = sessionProvider
    }
    
    func run<T: JSONDecodable>(request: BaseRequest) -> Promise<T> {
        return runRaw(request: request).map { (data) in
            return try T.decode(data, decoder: JSONDecoder())
        }
    }
    
    func run(request: BaseRequest) -> Promise<Void> {
        return runRaw(request: request).map { _ in () }
    }
    
    func upload<T: JSONDecodable>(request: UploadRequest) -> Promise<T> {
        return uploadRaw(request: request).map { (data) in
            return try T.decode(data, decoder: JSONDecoder())
        }
    }
    
    func upload(request: UploadRequest) -> Promise<Void> {
        return uploadRaw(request: request).map { _ in () }
    }
    
    // MARK:-  private
    private func runRaw(request: BaseRequest) -> Promise<Data?> {
        let task = session(from: request).request(request)
        
        return Promise { seal in
            task
                .validate()
                .response(completionHandler: { (response) in
                    switch response.result {
                    case .success(let data):
                        seal.fulfill(data)
                    case .failure(let err):
                        let error = RequestExecutor.convert(error: err)
                        seal.reject(error)
                    }
                })
        }
    }
    
    private func uploadRaw(request: UploadRequest) -> Promise<Data?> {
        let mpfd = MultipartFormData(fileManager: FileManager.default)
        mpfd.append(request.data, withName: request.name, fileName: request.fileName, mimeType: request.mimeType)
        
        let task = session(from: request).upload(multipartFormData: mpfd, with: request)
        return Promise { seal in
            task
                .validate()
                .response(completionHandler: { (response) in
                    switch response.result {
                    case .success(let data):
                        seal.fulfill(data)
                    case .failure(let err):
                        let error = RequestExecutor.convert(error: err)
                        seal.reject(error)
                    }
                })
        }
    }
    
    private func session(from request: BaseRequest) -> Session {
        switch request.auth {
        case .bearer:
            return sessionProvider.authSession
        case .notRequired:
            return sessionProvider.rawSession
        }
    }

    private static func convert(error: Error) -> Error {
        guard let afError = error as? AFError, let underlyingError = afError.underlyingError else {
            return ServiceError.network(error)
        }
        
        if underlyingError is ServiceError {
            return underlyingError
        }
        
        return ServiceError.network(underlyingError)
    }
    
    private let sessionProvider: AfSessionProvider
}


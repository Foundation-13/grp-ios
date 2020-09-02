import UIKit
import Combine
import PromiseKit

enum UploadErr: Error {
    case convertToPNG
}

struct UploadProgress {
    let id: Int
    let total: Int
    let uploaded: Int
}

enum UploadEvent {
    case starting(Int)
    case started(Int)
    case progress(UploadProgress)
    case completed(Int)
    case failed(Int, UploadErr)
}

protocol UploadAPIProvider {
    func uploadImage(_ data: Data, index: Int, forJob id: Int) -> Promise<Void>
    func completeJob(id: Int) -> Promise<Void>
}

typealias UploadStarterFn = () -> Promise<Int>


protocol UploadProvider {
    func startNewUpload(starter: @escaping UploadStarterFn, images: [UIImage]) -> Promise<Void>
    func currentUploads() -> Promise<[UploadProgress]>
    
    var uploadEvents: AnyPublisher<UploadEvent, Never> { get }
}

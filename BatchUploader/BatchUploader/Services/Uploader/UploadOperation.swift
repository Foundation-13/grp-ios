import Foundation
import PromiseKit

final class UploadOperation: Operation {

    init(jobId: Int, index: Int, storage: StorageProviver, db: JobsDBProvider, api: UploadAPIProvider) {
        self.jobId = jobId
        self.index = index
        self.storage = storage
        self.db = db
        self.api = api
    }
    
    override func main() {
        do {
            try firstly {
                readFile()
            }.then { (data) -> Promise<Void> in
                return self.api.uploadImage(data, index: self.index, forJob: self.jobId)
            }.done {
                try self.db.markStepCompleted(self.index, forJob: self.jobId)
            }.wait()
        } catch let err {
            print("Upload failed, \(jobId), \(index), \(err)")
        }
    }

    // MARK:- private
    private func readFile() -> Promise<Data> {
        return Promise { seal in
            let data = try storage.readFile(path: "/uploads/\(jobId)/\(index)")
            seal.fulfill(data)
        }
    }
    
    private let jobId: Int
    private let index: Int
    private let storage: StorageProviver
    private let db: JobsDBProvider
    private let api: UploadAPIProvider
}

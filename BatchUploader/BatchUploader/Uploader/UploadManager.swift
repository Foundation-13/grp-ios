//
//  UploadManager.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import UIKit
import Combine
import PromiseKit

enum UploadError: Error {
    case convertToPNG
    case jobNotFound
}

struct UploadProgress {
    let id: String
    let total: Int
    let uploaded: Int
}

enum UploadEvent {
    case starting(String)
    case started(String)
    case progress(UploadProgress)
    case completed(String)
    case failed(String, UploadError)
}


final class UploadManager {
    
    static let shared: UploadManager = UploadManager(storage: Storage(), jobsDB: DummyJobsDB(), uploader: DummyUploader())
    
    init(storage: StorageProviver, jobsDB: JobsDBProvider, uploader: ImageUploader) {
        self.storage = storage
        self.jobsDB = jobsDB
        self.uploader = uploader
        
        queue.maxConcurrentOperationCount = 1
    }
    
    func startNewUpload(id: String, images: [UIImage]) -> Promise<Void> {
        return firstly {
            prepareFolderForJob(id: id, images: images)
        }.then(on: self.bgq) {
            self.saveJob(id: id, steps: images.count)
        }.then(on: self.bgq) {
            self.startJob(id: id, steps: images.count)
        }
    }
    
    func currentUploads() -> [UploadProgress] {
        return []
    }
    
    var uploadEvents: AnyPublisher<UploadEvent, Never> {
        return uploadSubject.eraseToAnyPublisher()
    }
    
    // MARK:- private
    private func updateProgress(_ e: UploadEvent) {
        DispatchQueue.main.async {
            self.uploadSubject.send(e)
        }
    }
    
    private func prepareFolderForJob(id: String, images: [UIImage]) -> Promise<Void> {
        return Promise().then(on: bgq) { _ -> Promise<Void> in
            self.updateProgress(.starting(id))
            
            // create folder and copy files
            try self.storage.makeFolder(path: "/uploads/\(id)")
            
            for (indx, img) in images.enumerated() {
                let fileName = "/uploads/\(id)/\(indx)"
                guard let data = img.pngData() else {
                    throw UploadError.convertToPNG
                }
                
                try self.storage.writeFile(path: fileName, data: data)
            }
            
            return Promise()
        }
    }
    
    private func saveJob(id: String, steps: Int) -> Promise<Void> {
        return Promise { seal in
            try self.jobsDB.createJob(id: id, steps: steps)
            seal.fulfill(())
        }
    }
    
    private func startJob(id: String, steps: Int) -> Promise<Void> {
        return Promise { seal in
            for indx in 0..<steps {
                let operation = UploadOperation(jobId: id, index: indx, storage: storage, db: jobsDB, uploader: uploader)
                operation.completionBlock = { [weak self] in
                    guard let self = self else { return }
                    
                    do {
                        guard let status = self.jobsDB.getJobStatus(id: id) else {
                            throw UploadError.jobNotFound
                        }
                        
                        let p = UploadProgress(id: id, total: status.totalCount, uploaded: status.completedCount)
                        self.updateProgress(.progress(p))
                        
                        if status.isFinished {
                            try self.jobsDB.completeJob(id: id)
                            self.updateProgress(.completed(id))
                        }
                    } catch let err {
                        print("something bad in completion block \(err)")
                    }
                }
                
                queue.addOperation(operation)
            }
            
            seal.fulfill(())
        }
    }
    
    // MARK:- private
    
    private let uploadSubject = PassthroughSubject<UploadEvent, Never>()
    
    private let storage: StorageProviver
    private let uploader: ImageUploader
    private let jobsDB: JobsDBProvider
    
    private let queue = OperationQueue()
    
    private let bgq = DispatchQueue.global(qos: .userInitiated)
}


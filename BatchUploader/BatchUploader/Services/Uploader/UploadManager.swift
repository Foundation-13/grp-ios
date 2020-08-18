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

final class UploadManager {
    
    init(storage: StorageProviver, jobsDB: JobsDBProvider, uploader: ImageUploader) {
        self.storage = storage
        self.jobsDB = jobsDB
        self.uploader = uploader
        
        queue.maxConcurrentOperationCount = 1
        
        restoreUploads()
    }
    
    // MARK:- private
    
    private func restoreUploads() {
        bgq.async { [weak self] in
            guard let self = self else { return }
            
            do {
                let jobs = try self.jobsDB.getActiveJobs() // TODO: Возвращать сразу со статусами
                for job in jobs {
                    self.startJob(id: job.id, steps: job.remaining).catch { (err) in
                        print("start job error \(err)")
                    }
                }
            }
            catch let err {
                print("restore jobs error \(err)")
            }
        }
    }
    
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
                    throw UploadErr.convertToPNG
                }
                
                try self.storage.writeFile(path: fileName, data: data)
            }
            
            return Promise()
        }
    }
    
    private func saveJob(id: String, steps: [Int]) -> Promise<Void> {
        return Promise { seal in
            try self.jobsDB.createJob(id: id, steps: steps)
            seal.fulfill(())
        }
    }
    
    private func startJob(id: String, steps: [Int]) -> Promise<Void> {
        return Promise { seal in
            for indx in steps {
                let operation = UploadOperation(jobId: id, index: indx, storage: storage, db: jobsDB, uploader: uploader)
                operation.completionBlock = { [weak self] in
                    guard let self = self else { return }
                    
                    do {
                        let status = try self.jobsDB.getJobStatus(id: id)
                        
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

extension UploadManager: UploadProvider {
    func startNewUpload(id: String, images: [UIImage]) -> Promise<Void> {
        let steps = (0..<images.count).map { $0 }
        
        return firstly {
            prepareFolderForJob(id: id, images: images)
        }.then(on: self.bgq) {
            self.saveJob(id: id, steps: steps)
        }.then(on: self.bgq) {
            self.startJob(id: id, steps: steps)
        }
    }
    
    func currentUploads() -> Promise<[UploadProgress]> {
        return Promise { seal in
            let jobs = try jobsDB.getActiveJobs()
            let progress = jobs.map { UploadProgress(id: $0.id, total: $0.totalCount, uploaded: $0.completedCount) }
            
            seal.fulfill(progress)
        }
    }
    
    var uploadEvents: AnyPublisher<UploadEvent, Never> {
        return uploadSubject.eraseToAnyPublisher()
    }
}

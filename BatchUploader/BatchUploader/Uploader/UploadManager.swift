//
//  UploadManager.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import UIKit
import Combine

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
    
    func startNewUpload(id: String, images: [UIImage]) throws {
        // create folder and copy files
        try storage.makeFolder(path: "/uploads/\(id)")
        
        var steps = [String]()
        for (indx, img) in images.enumerated() {
            let fileName = "/uploads/\(id)/\(indx)"
            guard let data = img.pngData() else {
                throw UploadError.convertToPNG
            }
            
            try storage.writeFile(path: fileName, data: data)
            steps.append("\(indx)")
        }
        
        // save upload into the db
        jobsDB.createJob(id: id, steps: steps)
        
        // start upload task
        for indx in 0..<images.count {
            queue.addOperation(UploadOperation(jobId: id, index: indx, storage: storage, db: jobsDB, uploader: uploader))
        }
    }
    
    func currentUploads() -> [UploadProgress] {
        return []
    }
    
    var uploadEvents: AnyPublisher<UploadEvent, Never> {
        return uploadSubject.eraseToAnyPublisher()
    }
    
    // MARK:- private
    private let uploadSubject = PassthroughSubject<UploadEvent, Never>()
    
    private let storage: StorageProviver
    private let uploader: ImageUploader
    private let jobsDB: JobsDBProvider
    
    private let queue = OperationQueue()
}


//
//  UploadOperation.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

final class UploadOperation: Operation {

    init(jobId: String, index: Int, storage: StorageProviver, db: JobsDBProvider, uploader: ImageUploader) {
        self.jobId = jobId
        self.index = index
        self.storage = storage
        self.db = db
        self.uploader = uploader
    }
    
    override func main() {
        do {
            let data = try storage.readFile(path: "/uploads/\(jobId)/\(index)")
            uploader.uploadImage(data, index: index, forJob: jobId)
            try db.markStepCompleted(forJob: jobId)
        } catch let err {
            print("failed to upload \(err)")
        }
    }
    
    private let jobId: String
    private let index: Int
    private let storage: StorageProviver
    private let db: JobsDBProvider
    private let uploader: ImageUploader
}

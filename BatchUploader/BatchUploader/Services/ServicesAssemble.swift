//
//  ServicesAssemble.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 17.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation


// TODO: temporary solution, use protocol/factory instead
final class ServicesAssemble {
    
    static let shared = ServicesAssemble()
    
    lazy var uploadProvider: UploadProvider = {
        return UploadManager(storage: storage, jobsDB: jobsDB, uploader: imageUploader)
    }()
    
    // MARK:- private
    
    private lazy var storage: Storage = {
       return Storage()
    }()
    
    private var jobsDB: JobsDBProvider {
       return database
    }
    
    private lazy var imageUploader: ImageUploader = {
        return DummyImageUploader()
    }()
    
    private lazy var database: DatabaseWrapper = {
        do {
            return try DatabaseWrapper(dbName: "uploader.db")
        } catch let err {
            fatalError("failed to open db: \(err)")
        }
    }()
}

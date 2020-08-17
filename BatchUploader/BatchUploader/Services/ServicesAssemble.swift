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
    
    private lazy var jobsDB: JobsDBProvider = {
       return DummyJobsDB()
    }()
    
    private lazy var imageUploader: ImageUploader = {
        return DummyImageUploader()
    }()
}

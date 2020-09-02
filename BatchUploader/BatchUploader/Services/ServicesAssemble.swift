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
        return UploadManager(storage: storage, jobsDB: jobsDB, api: imageUploadAPI)
    }()
    
    lazy var location: LocationProvider = {
        return LocationService()
    }()
    
    lazy var profile: UserProfileProvider = {
       return UserProfileService(executor: requestExecutor, imageProcessor: imageProcessor)
    }()
    
    lazy var places: PlacesProvider = {
        return PlacesService(executor: requestExecutor)
    }()
    
    lazy var review: ReviewProvider = {
        return ReviewService(executor: requestExecutor)
    }()

    lazy var healthcheckProvider: HealthcheckProvider = {
       HealthcheckService(executor: requestExecutor)
    }()
    
    // MARK:- private
    
    private lazy var userSession: UserSession = {
        UserSession()
    }()
    
    private lazy var requestExecutor: RequestExecutor = {
        RequestExecutor(sessionProvider: sessionProvider)
    }()
    
    private lazy var sessionProvider: AfSessionProvider = {
        let configuration = URLSessionConfiguration.default
        return AfSessionProviderImpl(configuration: configuration, userSession: userSession)
    }()
    
    private lazy var imageProcessor: ImageProcessor = {
        ImageProcessorImpl()
    }()

    private lazy var storage: Storage = {
       return Storage()
    }()
    
    private var jobsDB: JobsDBProvider {
       return database
    }
    
    private lazy var imageUploadAPI: UploadAPIProvider = {
        return UploadAPIAdapter(review: review)
    }()
    
    private lazy var database: DatabaseWrapper = {
        do {
            return try DatabaseWrapper(dbName: "uploader.db")
        } catch let err {
            fatalError("failed to open db: \(err)")
        }
    }()
}

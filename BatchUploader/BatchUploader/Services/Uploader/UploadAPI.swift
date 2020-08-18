//
//  UploadAPI.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation
import PromiseKit


struct DummyUploadAPI: UploadAPIProvider {
    func uploadImage(_ data: Data, index: Int, forJob id: String) -> Promise<Void> {
        return after(seconds: 2).then { _ -> Promise<Void> in
            print("upload image \(index) for job \(id)")
            return Promise()
        }
    }
    
    func completeJob(id: String) -> Promise<Void> {
        return after(seconds: 1).then { _ -> Promise<Void> in
            print("completing job \(id)")
            return Promise()
        }
    }
}

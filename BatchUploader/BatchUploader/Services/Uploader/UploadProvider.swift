//
//  UploadProvider.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 17.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import UIKit
import Combine
import PromiseKit

enum UploadErr: Error {
    case convertToPNG
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
    case failed(String, UploadErr)
}

protocol UploadProvider {
    func startNewUpload(id: String, images: [UIImage]) -> Promise<Void>
    func currentUploads() -> Promise<[UploadProgress]>
    
    var uploadEvents: AnyPublisher<UploadEvent, Never> { get }
}

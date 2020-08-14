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
    
    func startNewUpload(id: String, images: [UIImage]) {
        
    }
    
    func currentUploads() -> [UploadProgress] {
        return []
    }
    
    var uploadEvents: AnyPublisher<UploadEvent, Never> {
        return uploadSubject.eraseToAnyPublisher()
    }
    
    // MARK:- private
    private let uploadSubject = PassthroughSubject<UploadEvent, Never>()
}

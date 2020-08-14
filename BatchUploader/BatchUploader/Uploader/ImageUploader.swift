//
//  ImageUploader.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

protocol ImageUploader {
    func uploadImage(_ data: Data, index: Int, forJob id: String)
}

// MARK:- Implementation

struct DummyUploader: ImageUploader {
    func uploadImage(_ data: Data, index: Int, forJob id: String) {
        print("upload image \(index) for job \(id)")
        sleep(1)
    }
}

//
//  Uploader.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation
import UIKit

final class Uploader {
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func upload(_ images: [UIImage]) {
        // save images for the safe upload
        
        do {
            let folder = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: URL(string: "/batch-1/")!, create: true)
            
            images[0].pngData()
        } catch let err {
            print("some error: \(err)")
        }
    }
    
    private let fileManager: FileManager
}

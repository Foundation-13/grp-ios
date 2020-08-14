//
//  Model.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 13.08.2020.
//

import Foundation
import Combine
import UIKit

final class NewUploadModel: ObservableObject {
    @Published var readyForUpload = false
    @Published var selectedImages: [UIImage] = []
    
    func upload() {
        guard !selectedImages.isEmpty else { return }
        
        do {
            let id = "u-\(UUID().uuidString)"
            try UploadManager.shared.startNewUpload(id: id, images: selectedImages)
            print("Upload started with id: \(id)")
        } catch let err {
            print("failed to start upload: \(err)")
        }
    }
}

extension NewUploadModel: ImagePickerDelegate {
    func imagePicker(_ picker: ImagePickerView, didSelectImage image: UIImage) {
        selectedImages.append(image)
        readyForUpload = true
    }
}

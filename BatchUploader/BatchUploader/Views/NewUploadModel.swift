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
        
        
    }
}

extension NewUploadModel: ImagePickerDelegate {
    func imagePicker(_ picker: ImagePickerView, didSelectImage image: UIImage) {
        selectedImages.append(image)
        readyForUpload = true
    }
}

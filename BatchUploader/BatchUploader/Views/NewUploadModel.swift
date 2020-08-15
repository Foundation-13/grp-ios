//
//  Model.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 13.08.2020.
//

import Combine
import SwiftUI
import UIKit
import PromiseKit

final class NewUploadModel: ObservableObject {
    init(isActive: Binding<Bool>) {
        self.isActive = isActive
    }
    
    deinit {
        print("NewUploadModel deinit")
    }
    
    @Published var readyForUpload = false
    @Published var isLoading = false
    @Published var selectedImages: [UIImage] = []
    
    func upload() {
        guard !selectedImages.isEmpty else { return }
        
        self.isLoading = true
        
        firstly {
            createRecordOnServer()
        }.then { id in
            UploadManager.shared.startNewUpload(id: id, images: self.selectedImages)
        }.done {
            self.isActive.wrappedValue = false
        }.catch { (err) in
            print("Fuck!!! \(err)")
        }
    }
    
    private func createRecordOnServer() -> Promise<String> {
        return Promise { seal in
            let id = "u-\(UUID().uuidString)"
            seal.fulfill(id)
        }
    }
    
    private var isActive: Binding<Bool>
}

extension NewUploadModel: ImagePickerDelegate {
    func imagePicker(_ picker: ImagePickerView, didSelectImage image: UIImage) {
        selectedImages.append(image)
        readyForUpload = true
    }
}

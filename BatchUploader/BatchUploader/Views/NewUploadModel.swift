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
    
    @Published var readyForUpload = false
    @Published var isLoading = false
    @Published var selectedImages: [UIImage] = []
    
    deinit {
        print("NewUploadModel deinit")
    }
    
    func cancel() {
        self.isActive.wrappedValue = false
    }
    
    func upload() {
        guard !selectedImages.isEmpty else { return }
        
        self.isLoading = true
        
        firstly {
            createRecordOnServer()
        }.then { id in
            ServicesAssemble.shared.uploadManager.startNewUpload(id: id, images: self.selectedImages)
        }.ensure {
            self.isLoading = false
        }.done {
            print("upload started, close window")
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

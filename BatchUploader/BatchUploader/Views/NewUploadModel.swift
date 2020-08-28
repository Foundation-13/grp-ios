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
        self.uploader = ServicesAssemble.shared.uploadProvider
    }
    
    @Published var readyForUpload = false
    @Published var isLoading = false
    @Published var selectedImages: [UIImage] = []
        
    func cancel() {
        self.isActive.wrappedValue = false
    }
    
    func upload() {
        guard !selectedImages.isEmpty else { return }
        
        self.isLoading = true
        
        firstly {
            self.uploader.startNewUpload(starter: { self.createRecordOnServer() }, images: self.selectedImages)
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
    private var uploader: UploadProvider
    
    private var imagesWithLocation: [ImageWithLocation] = []
}

extension NewUploadModel: ImagePickerDelegate {
    func imagePicker(_ picker: ImagePickerView, didSelectImage image: ImageWithLocation) {
        selectedImages.append(image.image)
        imagesWithLocation.append(image)
        
        if let loc = image.location {
            print("Added image with location: \(loc)")
        }
        
        readyForUpload = true
    }
}

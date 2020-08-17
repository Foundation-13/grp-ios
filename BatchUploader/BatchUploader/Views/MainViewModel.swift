//
//  MainViewModel.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation
import Combine

struct UploadViewState: Identifiable {
    let name: String
    let status: String
    let totalSteps: Int
    let completedSteps: Int
    
    var id: String { return name }
    
    var progress: Float {
        if totalSteps == 0 {
            return 0.0
        }
        
        return Float(completedSteps) / Float(totalSteps)
    }
}


final class MainViewModel: ObservableObject {
    
    init() {
        self.uploadProvider = ServicesAssemble.shared.uploadProvider
        
        self.cancellable = uploadProvider.uploadEvents.sink(receiveValue: { [weak self] (event) in
            guard let self = self else { return }
            print("received upload event: \(event)")
            
            if !self.visible {
                return
            }
            
            switch event {
            case .starting(let id):
                self.addNewUpload(id: id)
            case .failed(_, _):
                break
            case .started(_):
                break
            case .progress(let progress):
                self.progress(progress)
            case .completed(let id):
                self.completeUpload(id: id)
            }
            
        })
    }
    
    func viewDidAppear() {
        visible = true
        uploadProvider.currentUploads().done {
            self.uploads = $0.map {
                UploadViewState(name: $0.id, status: "In progress", totalSteps: $0.total, completedSteps: $0.uploaded)
            }
        }.catch { err in
            print("failed to retrieve current uploads state")
        }
    }
    
    func viewDidDisappear() {
        visible = false
    }
    
    @Published var uploads = [UploadViewState]()
    
    // MARK:- private
    private func addNewUpload(id: String) {
        uploads = uploads.with(newElement: UploadViewState(name: id, status: "Starting", totalSteps: 0, completedSteps: 0))
    }
    
    private func completeUpload(id: String) {
        uploads = uploads.removedFirst { $0.id == id }
    }
    
    private func progress(_ p: UploadProgress) {
        uploads = uploads.map {
            if $0.id == p.id {
                return UploadViewState(name: $0.id, status: "In progress", totalSteps: p.total, completedSteps: p.uploaded)
            }
            
            return $0
        }
    }
    
    private let uploadProvider: UploadProvider
    private var cancellable: AnyCancellable?
    private var visible = false
}

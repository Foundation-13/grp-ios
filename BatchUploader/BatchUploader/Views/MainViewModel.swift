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
        if completedSteps == 0 {
            return 0.0
        }
        
        return Float(totalSteps) / Float(completedSteps)
    }
}


final class MainViewModel: ObservableObject {
    
    init() {
        self.cancellable = Upload.manager.uploadEvents.sink(receiveValue: { [weak self] (event) in
            guard let self = self else { return }
            
            print("received upload event: \(event)")
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
    
    @Published var uploads = [UploadViewState]()
    
    private var cancellable: AnyCancellable?
    
    private func addNewUpload(id: String) {
        var v = uploads
        v.append(UploadViewState(name: id, status: "Starting", totalSteps: 0, completedSteps: 0))
        uploads = v 
    }
    
    private func completeUpload(id: String) {
        
    }
    
    private func progress(_ p: Upload.Progress) {
        uploads = uploads.map {
            if $0.id == p.id {
                return UploadViewState(name: $0.id, status: "In progress", totalSteps: p.total, completedSteps: p.uploaded)
            }
            
            return $0
        }
    }
    
}

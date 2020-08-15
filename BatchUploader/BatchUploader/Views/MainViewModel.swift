//
//  MainViewModel.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    
    init() {
        self.cancellable = UploadManager.shared.uploadEvents.sink(receiveValue: { (event) in
            print("received upload event: \(event)")
        })
    }
        
    private var cancellable: AnyCancellable?
    
}

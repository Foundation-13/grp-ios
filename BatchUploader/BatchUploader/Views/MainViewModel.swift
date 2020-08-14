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
    
    func newUploadModel() -> NewUploadModel {
        return NewUploadModel()
    }
    
}

//
//  ArrayEx.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 17.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

extension Array {
    
    func with(newElement e: Element) -> Array {
        var t = self
        t.append(e)
        return t
    }
    
    func removedFirst(where check: (Element) throws -> Bool) rethrows -> Array {
        var t = self
        if let indx = try t.firstIndex(where: check) {
            t.remove(at: indx)
        }
        
        return t
    }
}

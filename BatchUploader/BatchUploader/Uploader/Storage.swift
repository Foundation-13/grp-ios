//
//  Disk.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

protocol StorageProviver {
    func makeFolder(path: String) throws
    
    func writeFile(path: String, data: Data) throws
    func readFile(path: String) throws -> Data
    
    func removeObject(path: String) throws
    func isObjectExists(path: String) -> Bool
}


// MARK:- impl

struct Storage: StorageProviver {
    
    init(fileManager: FileManager = FileManager.default) {
        self.fm = fileManager
        
        guard let root = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("couldn't open root folder")
        }
        
        self.root = root
    }
    
    func makeFolder(path: String) throws {
        let url = root.appendingPathComponent(path)
        try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    
    
    func writeFile(path: String, data: Data) throws {
        let url = root.appendingPathComponent(path)
        try data.write(to: url)
    }
    
    func readFile(path: String) throws -> Data {
        let url = root.appendingPathComponent(path)
        return try Data(contentsOf: url)
    }
    
    func removeObject(path: String) throws {
        let url = root.appendingPathComponent(path)
        try fm.removeItem(at: url)
    }
    
    func isObjectExists(path: String) -> Bool {
        let url = root.appendingPathComponent(path)
        
        return fm.fileExists(atPath: url.path)
    }
    
    private let fm: FileManager
    private let root: URL
}

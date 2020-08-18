//
//  Wrapper.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 17.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation
import GRDB

final class DatabaseWrapper {
    
    init(dbName: String) throws {
        let databaseURL = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        
        dbQueue = try DatabaseQueue(path: databaseURL.path)
        
        try migrator.migrate(dbQueue)
    }
    
    let dbQueue: DatabaseQueue
    
    private let migrator: DatabaseMigrator = {
        var migrator = DatabaseMigrator()
        
            migrator.registerMigration("v1") { db in
                try db.create(table: "upload_jobs") { t in
                    t.column("job_id", .text).notNull()
                    t.column("created", .datetime).notNull()
                    t.primaryKey(["job_id"])
                }
                
                try db.create(table: "upload_job_steps") { t in
                    t.column("job_id", .text).notNull()
                    t.column("step", .integer).notNull()
                    t.column("completed", .boolean).notNull()
                    t.uniqueKey(["job_id", "step"])
                }
            }
            
            migrator.eraseDatabaseOnSchemaChange = true
            
            return migrator
    }()
}

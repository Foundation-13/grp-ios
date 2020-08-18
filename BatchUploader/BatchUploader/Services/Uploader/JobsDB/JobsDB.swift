//
//  UploadsDB.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation
import GRDB


// MARK:- Implementation

extension DatabaseWrapper: JobsDBProvider {
    func createJob(id: String, steps: [Int]) throws {
        try dbQueue.write { db in
            try db.execute(
                sql: "INSERT INTO upload_jobs(job_id, created) VALUES(?, ?)",
                arguments: [id, Date()])
            
            for s in steps {
                try db.execute(
                    sql: "INSERT INTO upload_job_steps(job_id, step, completed) VALUES(?, ?, ?)",
                    arguments: [id, s, false])
            }
        }
    }
    
    func markStepCompleted(_ step: Int, forJob id: String) throws {
        try dbQueue.write{ db in
            try db.execute(
                sql: "UPDATE upload_job_steps SET completed = true WHERE job_id = :job_id AND step = :step",
                arguments: ["job_id": id, "step": step])
        }
    }
    
    func getJobStatus(id: String) throws -> JobStatus {
        return try dbQueue.read { (db) -> JobStatus in
            let completedRows = try Row.fetchAll(db, sql: "SELECT step FROM upload_job_steps WHERE job_id = ? AND completed = true", arguments: [id])
            let remainingRows = try Row.fetchAll(db, sql: "SELECT step FROM upload_job_steps WHERE job_id = ? AND completed = false", arguments: [id])
            
            let completed = completedRows.map { (row) -> Int in row["step"] }
            let remaining = remainingRows.map { (row) -> Int in row["step"] }
            
            return JobStatus(completed: completed, remaining: remaining)
        }
    }
    
    func completeJob(id: String) throws {
        try dbQueue.write { (db) in
            try db.execute(sql: "DELETE FROM upload_job_steps WHERE job_id = ?", arguments: [id])
            try db.execute(sql: "DELETE FROM upload_jobs WHERE job_id = ?", arguments: [id])
        }
    }
    
    func getActiveJobs() throws -> [String] {
        return try dbQueue.read { (db) -> [String] in
            let jobs = try Row.fetchAll(db, sql: "SELECT job_id FROM upload_jobs", arguments: [])
            return jobs.map { (row) -> String in row["job_id"] }
        }
    }
}

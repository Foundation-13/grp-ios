//
//  UploadsDB.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

struct JobStatus {
    let completed: Int
    let total: Int
    
    var remaining: Int { total - completed }
}

protocol JobsDBProvider {
    func createJob(id: String, steps: Int)  throws
    
    func markStepCompleted(forJob id: String) throws
    func getJobStatus(id: String) -> JobStatus?
    
    func completeJob(id: String) throws
    
    func getActiveJobs() -> [String]
}

// MARK:- Implementation
final class DummyJobsDB: JobsDBProvider {
    
    func createJob(id: String, steps: Int) throws {
        print("created job \(id), steps \(steps)")
        jobs[id] = JobStatus(completed: 0, total: steps)
    }
    
    func markStepCompleted(forJob id: String) throws {
        guard let job = jobs[id] else { throw UploadError.jobNotFound }
        
        let newStatus = JobStatus(completed: job.completed + 1, total: job.total)
        print("job \(id), new status \(newStatus)")
        
        jobs[id] = newStatus
    }
    
    func completeJob(id: String) throws {
        print("job \(id) completed")
        jobs.removeValue(forKey: id)
    }
    
    func getJobStatus(id: String) -> JobStatus? {
        return jobs[id]
    }
    
    func getActiveJobs() -> [String] {
        return Array<String>(jobs.keys)
    }
    
    private var jobs = [String: JobStatus]()
}

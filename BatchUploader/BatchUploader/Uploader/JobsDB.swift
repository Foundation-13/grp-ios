//
//  UploadsDB.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

struct JobStatus {
    let completed: [String]
    let remaining: [String]
}

protocol JobsDBProvider {
    func createJob(id: String, steps: [String])
    
    func markCompleted(step: String, forJob id: String) throws
    func completeJob(id: String)
    func getJobStatus(id: String) -> JobStatus?
    
    
    func getActiveJobs() -> [String]
}

// MARK:- Implementation
final class DummyJobsDB: JobsDBProvider {
    func createJob(id: String, steps: [String]) {
        print("created job \(id), steps \(steps)")
        jobs[id] = JobStatus(completed: [], remaining: steps)
    }
    
    func markCompleted(step: String, forJob id: String) throws {
        guard let job = jobs[id] else { throw UploadError.jobNotFound }
        
        print("job \(id), step \(step) completed")
        
        if let stepIndex = job.remaining.firstIndex(of: step) {
            var completed = job.completed
            var remaining = job.remaining
            
            completed.append(step)
            remaining.remove(at: stepIndex)
            
            jobs[id] = JobStatus(completed: completed, remaining: remaining)
        }
    }
    
    func completeJob(id: String) {
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

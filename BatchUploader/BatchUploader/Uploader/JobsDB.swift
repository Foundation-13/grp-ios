//
//  UploadsDB.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

struct JobStatus {
    let completed: [Int]
    let remaining: [Int]
    
    var totalCount: Int {
        return completed.count + remaining.count
    }
    
    var completedCount: Int {
        return completed.count
    }
    
    var isFinished: Bool {
        return remaining.isEmpty
    }
}

protocol JobsDBProvider {
    func createJob(id: String, steps: Int)  throws
    
    func markStepCompleted(_ step: Int, forJob id: String) throws
    func getJobStatus(id: String) -> JobStatus?
    
    func completeJob(id: String) throws
    
    func getActiveJobs() -> [String]
}

// MARK:- Implementation
final class DummyJobsDB: JobsDBProvider {
    
    func createJob(id: String, steps: Int) throws {
        print("created job \(id), steps \(steps)")
        
        let remaining = (0..<steps).map { $0 }
        jobs[id] = JobStatus(completed: [], remaining: remaining)
    }
    
    func markStepCompleted(_ step: Int, forJob id: String) throws {
        guard let job = jobs[id] else { throw UploadError.jobNotFound }
        
        if let index = job.remaining.firstIndex(of: step) {
            var newCompleted = job.completed
            var newRemaining = job.remaining
            
            newCompleted.append(step)
            newRemaining.remove(at: index)
            
            let newStatus = JobStatus(completed: newCompleted, remaining: newRemaining)
            print("job \(id), new status \(newStatus)")
            jobs[id] = newStatus
        } // TODO: job not found!
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

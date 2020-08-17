//
//  DummyJobsDB.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 16.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

final class DummyJobsDB: JobsDBProvider {
    
    func createJob(id: String, steps: Int) throws {
        print("created job \(id), steps \(steps)")
        
        let remaining = (0..<steps).map { $0 }
        jobs[id] = JobStatus(completed: [], remaining: remaining)
    }
    
    func markStepCompleted(_ step: Int, forJob id: String) throws {
        try performWithLock {
            guard let job = jobs[id] else { throw JobDBErr.jobNotFound(id: id) }
            guard let index = job.remaining.firstIndex(of: step) else { throw JobDBErr.stepNotFound(job: id, step: step) }
            
            var newCompleted = job.completed
            var newRemaining = job.remaining
                
            newCompleted.append(step)
            newRemaining.remove(at: index)
                
            let newStatus = JobStatus(completed: newCompleted, remaining: newRemaining)
            print("job \(id), new status \(newStatus)")
            jobs[id] = newStatus
        }
    }
    
    func completeJob(id: String) throws {
        try performWithLock {
            print("job \(id) completed")
            jobs.removeValue(forKey: id)
        }
    }
    
    func getJobStatus(id: String) throws -> JobStatus {
        guard let job = jobs[id] else { throw JobDBErr.jobNotFound(id: id) }
        return job
    }
    
    func getActiveJobs() -> [String] {
        return Array<String>(jobs.keys)
    }
    
    // MARK:- private
    
    private func performWithLock(_ fn: () throws -> Void) throws {
        defer { lock.unlock() }
        lock.lock()
        try fn()
    }
    
    private var jobs = [String: JobStatus]()
    private let lock = NSLock()
}
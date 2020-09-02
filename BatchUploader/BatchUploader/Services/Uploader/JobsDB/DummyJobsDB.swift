import Foundation

final class DummyJobsDB: JobsDBProvider {
    
    func createJob(id: Int, steps: [Int]) throws {
        print("created job \(id), steps \(steps)")
        jobs[id] = JobStatus(id: id, completed: [], remaining: steps)
    }
    
    func markStepCompleted(_ step: Int, forJob id: Int) throws {
        try performWithLock {
            guard let job = jobs[id] else { throw JobDBErr.jobNotFound(id: id) }
            guard let index = job.remaining.firstIndex(of: step) else { throw JobDBErr.stepNotFound(job: id, step: step) }
            
            var newCompleted = job.completed
            var newRemaining = job.remaining
                
            newCompleted.append(step)
            newRemaining.remove(at: index)
                
            let newStatus = JobStatus(id: id, completed: newCompleted, remaining: newRemaining)
            print("job \(id), new status \(newStatus)")
            jobs[id] = newStatus
        }
    }
    
    func completeJob(id: Int) throws {
        try performWithLock {
            print("job \(id) completed")
            jobs.removeValue(forKey: id)
        }
    }
    
    func getJobStatus(id: Int) throws -> JobStatus {
        guard let job = jobs[id] else { throw JobDBErr.jobNotFound(id: id) }
        return job
    }
    
    func getActiveJobs() throws -> [JobStatus] {
        return Array<JobStatus>(jobs.values)
    }
    
    // MARK:- private
    
    private func performWithLock(_ fn: () throws -> Void) throws {
        defer { lock.unlock() }
        lock.lock()
        try fn()
    }
    
    private var jobs = [Int: JobStatus]()
    private let lock = NSLock()
}

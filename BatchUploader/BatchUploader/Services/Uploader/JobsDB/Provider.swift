//
//  Provider.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 16.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import Foundation

enum JobDBErr: Error {
    case jobNotFound(id: Int)
    case stepNotFound(job: Int, step: Int)
    case dbError(Error)
}

struct JobStatus {
    let id: Int
    let completed: [Int]
    let remaining: [Int]
    
    var totalCount: Int { completed.count + remaining.count }
    var completedCount: Int { completed.count }
    
    var progress: Float { Float(completedCount) / Float(totalCount) }
    
    var isFinished: Bool { remaining.isEmpty }
}

protocol JobsDBProvider {
    func createJob(id: Int, steps: [Int]) throws
    
    func markStepCompleted(_ step: Int, forJob id: Int) throws
    func getJobStatus(id: Int) throws -> JobStatus
    
    func completeJob(id: Int) throws
    
    func getActiveJobs() throws -> [JobStatus]
}

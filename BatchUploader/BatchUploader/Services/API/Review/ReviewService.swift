import Foundation
import PromiseKit

protocol ReviewProvider {
    func create(review: Review) -> Promise<Void>
}

// MARK:- ReviewService

final class ReviewService {
    
    init(executor: RequestExecutor) {
        self.executor = executor
    }

    private let executor: RequestExecutor
    
    final class CreateReviewRequest: JsonRequest<Review> {
        init(review: Review) {
            super.init(endpoint: "/api/v1/reviews", method: .post, body: review)
        }
    }
}

extension ReviewService: ReviewProvider {
    func create(review: Review) -> Promise<Void> {
        return executor.run(request: CreateReviewRequest(review: review))
    }
}



import Foundation
import PromiseKit

protocol ReviewProvider {
    func create(review: Review) -> Promise<ObjectID>
    func addImageForReview(_ id: Int, image: Data, withNumber number: Int) -> Promise<Void>
    func completeReview(_ id: Int) -> Promise<Void>
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
    
    final class UploadImageRequest: UploadRequest {
        init(reviewID: Int, image: Data, number: Int) {
            super.init(endpoint: "/api/v1/reviews/review/\(reviewID)/images/\(number)", method: .post, data: image, name: "image")
        }
    }
    
    final class CompleteReviewRequest: BaseRequest {
        init(reviewID: Int) {
            super.init(endpoint: "/api/v1/reviews/review/\(reviewID)/complete", method: .put)
        }
    }
}

extension ReviewService: ReviewProvider {
    func create(review: Review) -> Promise<ObjectID> {
        return executor.run(request: CreateReviewRequest(review: review))
    }
    
    func addImageForReview(_ id: Int, image: Data, withNumber number: Int) -> Promise<Void> {
        return executor.upload(request: UploadImageRequest(reviewID: id, image: image, number: number))
    }
    
    func completeReview(_ id: Int) -> Promise<Void> {
        return executor.run(request: CompleteReviewRequest(reviewID: id))
    }
}



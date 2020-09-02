import Foundation
import PromiseKit

final class UploadAPIAdapter {
    init(review: ReviewProvider) {
        self.review = review
    }
    
    private let review: ReviewProvider
}

extension UploadAPIAdapter: UploadAPIProvider {
    func uploadImage(_ data: Data, index: Int, forJob id: Int) -> Promise<Void> {
        return review.addImageForReview(id, image: data, withNumber: index)
    }
    
    func completeJob(id: Int) -> Promise<Void> {
        return review.completeReview(id)
    }
}

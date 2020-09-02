import Foundation
import Combine
import SwiftUI
import UIKit
import PromiseKit

final class CreateReviewModel: ObservableObject {
    init(place: Places.Place, images: [UIImage]) {
        self.place = place
        self.images = images
        
        self.reviewProvider = ServicesAssemble.shared.review
        self.uploadProvider = ServicesAssemble.shared.uploadProvider
    }
    
    var name: String {
        return place.title
    }
    
    var address: String {
        return place.vicinity
    }
    
    @Published var rating: Int = 0
    @Published var text: String = ""
    
    @Published var isLoading = false
    @Published var isReviewCreated = false
    
    func createReview() {
        print("Create review: \(text), \(rating)")
        
        let review = Review(id: 0, creator: 0, location: place, text: text, stars: rating)
        
        isLoading = true
        
        uploadProvider.startNewUpload(starter: { () -> Promise<Int> in
            self.reviewProvider.create(review: review).map { $0.id }
        }, images: images).done { _ in
            self.isReviewCreated = true
        }.catch { (err) in
            print("Create review error: \(err)")
        }
    }
    
    private let place: Places.Place
    private let images: [UIImage]
    
    private let reviewProvider: ReviewProvider
    private let uploadProvider: UploadProvider
}

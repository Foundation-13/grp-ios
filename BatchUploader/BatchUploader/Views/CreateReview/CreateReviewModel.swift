import Foundation
import Combine
import SwiftUI

final class CreateReviewModel: ObservableObject {
    init(place: Places.Place) {
        self.place = place
        
        self.reviewProvider = ServicesAssemble.shared.review
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
        
        reviewProvider.create(review: review).done { _ in
            print("review created")
            self.isReviewCreated = true
        }.ensure {
            self.isLoading = false
        }.catch { (err) in
            print("Create review error: \(err)")
        }
    }
    
    private let place: Places.Place
    
    private let reviewProvider: ReviewProvider
}

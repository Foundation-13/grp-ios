import Foundation
import UIKit
import CoreLocation



struct ImageWithLocation {
    let image: UIImage
    let coord: CLLocationCoordinate2D
}

struct Cluster {
    let images: [UIImage]
    let places: [Places.PlaceWithDistance]
}

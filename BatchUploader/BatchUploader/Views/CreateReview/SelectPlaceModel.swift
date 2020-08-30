import Foundation
import UIKit
import Combine

struct ClusterViewState: Identifiable {
    struct PlaceViewState: Identifiable {
        var id: String {
            return place.externalID ?? ""
        }
        
        var name: String {
            return place.title
        }
        
        var address: String {
            return place.vicinity
        }
        
        var distStr: String {
            return "\(distance) meters"
        }

        let place: Places.Place
        let distance: Int
    }
    
    let id: Int
    
    let images: [UIImage]
    let places: [PlaceViewState]
}

final class SelectPlaceModel: ObservableObject {
    
    init(clusters: [Cluster] = []){
        self.viewState = makeViewState(clusters: clusters)
    }
    
    @Published var viewState: [ClusterViewState] = []
    
    private func makeViewState(clusters: [Cluster]) -> [ClusterViewState] {
        return clusters.enumerated().map { e in
            let placesVS = e.element.places.map { ClusterViewState.PlaceViewState(place: $0.place, distance: $0.distance) }
            
            return ClusterViewState(id: e.offset, images: e.element.images, places: placesVS)
        }
    }
}

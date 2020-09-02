import Combine
import SwiftUI
import UIKit
import PromiseKit
import CoreLocation

final class SelectPicturesModel: ObservableObject {
    init() {
        self.placesProvider = ServicesAssemble.shared.places
    }
    
    @Published var isLoading = false
    @Published var done = false
    @Published var selectedImages: [UIImage] = []
        
    var selectPlaceModel: SelectPlaceModel {
        return SelectPlaceModel(clusters: imagesClusters)
    }
    
    /*func upload() {
        guard !selectedImages.isEmpty else { return }
        
        self.isLoading = true
        
        firstly {
            self.uploader.startNewUpload(starter: { self.createRecordOnServer() }, images: self.selectedImages)
        }.ensure {
            self.isLoading = false
        }.done {
            self.isActive.wrappedValue = false
        }.catch { (err) in
            print("Fuck!!! \(err)")
        }
    }*/
    
    func getPlaces() {
        let points = imagesWithLocation
            .compactMap { $0.coord }
            .map { Point(latitude: $0.latitude, longitude: $0.longitude) }
            .enumerated()
            .map { PointWithID(id: "\($0.offset)", point: $0.element) }
        
        let req = Places.SearchByPointsReq(points: points)
        
        isLoading = true
        
        placesProvider.placesBy(points: req).done { (res) in
            print("Result: \(res)")
            
            self.imagesClusters = res.clusters.map { (cluster) -> Cluster in
                let ids = cluster.pointIDs.map { Int($0)! }
                let images = ids.map { self.imagesWithLocation[$0].image }
                
                return Cluster(images: images, places: cluster.places)
            }
            
            self.done = true
        }.ensure {
            self.isLoading = false
        }
        .catch { (err) in
            print("Error: \(err)")
        }
    }
    
    private func createRecordOnServer() -> Promise<String> {
        return Promise { seal in
            let id = "u-\(UUID().uuidString)"
            seal.fulfill(id)
        }
    }
    
    private var placesProvider: PlacesProvider
    
    private var imagesWithLocation: [ImageWithLocation] = []
    private var imagesClusters: [Cluster] = []
}

extension SelectPicturesModel: ImagePickerDelegate {
    func imagePickerDidSelectImage(_ image: UIImage, location: CLLocationCoordinate2D?) {
        guard let location = location else {
            print("**** No location")
            return
        }
        
        selectedImages.append(image)
        imagesWithLocation.append(ImageWithLocation(image: image, coord: location))
        
        print("Added image with location: \(location)")
    }
    
    func imagePickerCancel() {
        
    }
}

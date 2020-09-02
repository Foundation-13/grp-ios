import SwiftUI
import UIKit
import CoreLocation

final class AvatarPickerModel: ObservableObject {
    enum Step: Int, Identifiable {
        var id: Int { self.rawValue }
        
        case pick
        case crop
    }
        
    init(isActive: Binding<Bool>, image: Binding<ImageRef?>, source: UIImagePickerController.SourceType) {
        self.isActive = isActive
        self.image = image
        self.source = source
        
        self.step = .pick
    }
    
    @Published var step: Step
    
    var isActive: Binding<Bool>
    var image: Binding<ImageRef?>
    
    var source: UIImagePickerController.SourceType
    
    private(set) var pickedImage: UIImage!
}

extension AvatarPickerModel {
    func cancel() {
        self.isActive.wrappedValue = false
    }
    
    func cropped(image: UIImage) {
        // TODO: move to ImageProcessor
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let resultImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        self.image.wrappedValue = ImageRef.uiImage(resultImage)
        self.isActive.wrappedValue = false
    }
}

extension AvatarPickerModel: ImagePickerDelegate {
    func imagePickerDidSelectImage(_ image: UIImage, location: CLLocationCoordinate2D?) {
        self.pickedImage = image
        self.step = .crop
    }
    
    func imagePickerCancel() {
        self.isActive.wrappedValue = false
    }
}

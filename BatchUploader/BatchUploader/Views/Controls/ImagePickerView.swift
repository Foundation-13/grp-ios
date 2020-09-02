import SwiftUI
import UIKit
import Photos
import CoreLocation

protocol ImagePickerDelegate: class {
    func imagePickerDidSelectImage(_ image: UIImage, location: CLLocationCoordinate2D?)
    func imagePickerCancel()
}

struct ImagePickerView: UIViewControllerRepresentable {
    weak var delegate: ImagePickerDelegate?
    var source: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Self.Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = source
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Self.Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        
        init(_ imagePickerController: ImagePickerView) {
            self.parent = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let asset = info[.phAsset] as? PHAsset
            let location = asset?.location?.coordinate
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let delegate = parent.delegate {
                delegate.imagePickerDidSelectImage(image, location: location)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.delegate?.imagePickerCancel()
        }
    }
}

import SwiftUI
import UIKit
import Photos
import CoreLocation

struct ImageWithLocation {
    let image: UIImage
    let location: CLLocationCoordinate2D?
}

protocol ImagePickerDelegate: class {
    func imagePicker(_ picker: ImagePickerView, didSelectImage image: ImageWithLocation)
}

struct ImagePickerView: UIViewControllerRepresentable {
    weak var delegate: ImagePickerDelegate?
    
    func makeUIViewController(context: Self.Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
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
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let asset = info[.phAsset] as? PHAsset
            let location = asset?.location?.coordinate
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let delegate = parent.delegate {
                delegate.imagePicker(parent, didSelectImage: ImageWithLocation(image: image, location: location))
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

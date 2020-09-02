import SwiftUI
import UIKit
import CropViewController

struct AvatarCropView: UIViewControllerRepresentable {
    var model: AvatarPickerModel
    
    func makeUIViewController(context: Self.Context) -> CropViewController {
        let cropViewController = CropViewController(croppingStyle: .circular, image: model.pickedImage)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: CropViewController, context: Self.Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: AvatarCropView
        
        init(_ parent: AvatarCropView) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController,
                                didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.model.cropped(image: image)
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            parent.model.cancel()
        }
    }
}


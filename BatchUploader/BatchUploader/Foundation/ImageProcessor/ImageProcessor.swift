import Foundation
import UIKit
import PromiseKit

protocol ImageProcessor {
    func makeAvatarFrom(image: UIImage) -> Promise<Data>
}

// MARK:-
final class ImageProcessorImpl {
    static let queue = DispatchQueue(label: "image-processor.queue", qos: .userInitiated)
}

extension ImageProcessorImpl: ImageProcessor {
    func makeAvatarFrom(image: UIImage) -> Promise<Data> {
        return Promise { seal in
            Self.queue.async {
                if let data = image.jpegData(compressionQuality: 0.1) { // TODO: It's bullshit, use a normal algorithm
                    seal.fulfill(data)
                } else {
                    seal.reject(GeneralError.converting("coudn't create avatar from image"))
                }
            }
        }
    }
    
    //func reduceSize()
}


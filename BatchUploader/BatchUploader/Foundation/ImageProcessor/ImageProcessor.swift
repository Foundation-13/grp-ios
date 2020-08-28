import Foundation
import UIKit
import PromiseKit

protocol ImageProcessor {
    func imageToPng(_ image: UIImage) -> Promise<Data>
}

// MARK:-
final class ImageProcessorImpl {
    static let queue = DispatchQueue(label: "image-processor.queue", qos: .userInitiated)
}

extension ImageProcessorImpl: ImageProcessor {
    func imageToPng(_ image: UIImage) -> Promise<Data> {
        return Promise { seal in
            Self.queue.async {
                if let data = image.pngData() {
                    seal.fulfill(data)
                } else {
                    seal.reject(GeneralError.converting("Coudn't read data from png"))
                }
            }
        }
    }
}


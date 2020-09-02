import UIKit

enum ImageRef {
    case url(URL)
    case uiImage(UIImage)
        
    static var defaultAvatar: ImageRef {
        return .uiImage(UIImage(named: "default-avatar")!)
    }
}

import UIKit
import PromiseKit

protocol UserProfileProvider {
    func getProfile() -> Promise<UserProfile>
    
    func update(profile: UserProfile) -> Promise<Void>
    func updateAvatar(image: UIImage) -> Promise<Void>
    func updatePushToken(_ token: String) -> Promise<Void>
}

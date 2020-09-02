import Foundation
import Combine

final class RegisterProfileModel: ObservableObject {
    
    @Published var avatar: ImageRef?
    @Published var name = ""
    @Published var age: Int? = nil
    
    @Published var isLoading = false
    @Published var isNextAllowed = false
    
    @Published var isProfileRegistered = false
    
    func viewAppear() {
        cancelBag.collect {
            $name.sink { [weak self] _ in
                self?.checkNextAllowed()
            }
            
            $age.sink { [weak self] _ in
                self?.checkNextAllowed()
            }
            
            $avatar.sink { [weak self] _ in
                self?.checkNextAllowed()
            }
        }
    }
    
    func viewDisappear() {
        cancelBag.cancelAll()
    }
    
    func registerProfile() {
        guard let age = age, case .uiImage(let avatarImage) = avatar else { return }
        
        let profileProvider = ServicesAssemble.shared.profile
        
        let profile = UserProfile.make(name: name, age: age)
        
        isLoading = true
        profileProvider.update(profile: profile).then { _ in
            profileProvider.updateAvatar(image: avatarImage)
        }.done {
            print("profile updated")
        }.ensure {
            self.isLoading = false
        }
        .catch { (err) in
            print("profile update error")
        }
    }
    
    private func checkNextAllowed() {
        guard let age = age, age > 13 else { return }
        guard name.count > 2 && avatar != nil else { return }
        
        isNextAllowed = true
    }
    
    
    
    private var cancelBag = CancelBag()
}

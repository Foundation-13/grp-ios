import UIKit
import PromiseKit

final class UserProfileService {
    init(executor: RequestExecutor, imageProcessor: ImageProcessor) {
        self.executor = executor
        self.imageProcessor = imageProcessor
    }

    private let executor: RequestExecutor
    private let imageProcessor: ImageProcessor
    
    // MARK:- requests
    private final class GetProfileRequest: BaseRequest {
        init() {
            super.init(endpoint: "/api/v1/profile", method: .get)
        }
    }
    
    private final class UpdateProfileRequest: JsonRequest<UserProfile> {
        init(profile: UserProfile) {
            super.init(endpoint: "/api/v1/profile", method: .put, body: profile)
        }
    }
    
    private final class UpdateAvatarRequest: UploadRequest {
        init(data: Data) {
            super.init(endpoint: "/api/v1/profile/avatar", method: .put, data: data, name: "avatar")
        }
    }
    
    private final class SetTokenRequest: BaseRequest {
        init(token: String) {
            super.init(endpoint: "/api/v1/profile/push_token/\(token)", method: .put)
        }
    }
}

extension UserProfileService: UserProfileProvider {
    func getProfile() -> Promise<UserProfile> {
        return executor.run(request: GetProfileRequest())
    }
    
    func update(profile: UserProfile) -> Promise<Void> {
        return executor.run(request: UpdateProfileRequest(profile: profile))
    }
    
    func updateAvatar(image: UIImage) -> Promise<Void> {
        return firstly {
            imageProcessor.makeAvatarFrom(image: image)
        }.then { (data) -> Promise<Void> in
            return self.executor.upload(request: UpdateAvatarRequest(data: data))
        }
    }
    
    func updatePushToken(_ token: String) -> Promise<Void> {
        return executor.run(request: SetTokenRequest(token: token))
    }
}

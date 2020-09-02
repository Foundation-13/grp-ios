import Foundation
import Combine
import Photos

struct UploadViewState: Identifiable {
    let id: Int
    let status: String
    let totalSteps: Int
    let completedSteps: Int
    
    var name: String {
        return "Review with \(id)"
    }
    
    var progress: Float {
        if totalSteps == 0 {
            return 0.0
        }
        
        return Float(completedSteps) / Float(totalSteps)
    }
}

final class MainViewModel: ObservableObject {
    
    init() {
        self.uploadProvider = ServicesAssemble.shared.uploadProvider
        self.profileProvider = ServicesAssemble.shared.profile
        
        self.cancellable = uploadProvider.uploadEvents.sink(receiveValue: { [weak self] (event) in
            guard let self = self else { return }
            print("received upload event: \(event)")
            
            if !self.visible {
                return
            }
            
            switch event {
            case .starting(let id):
                self.addNewUpload(id: id)
            case .failed(_, _):
                break
            case .started(_):
                break
            case .progress(let progress):
                self.progress(progress)
            case .completed(let id):
                self.completeUpload(id: id)
            }
            
        })
    }
    
    func viewDidAppear() {
        visible = true
        uploadProvider.currentUploads().done {
            self.uploads = $0.map {
                UploadViewState(id: $0.id, status: "In progress", totalSteps: $0.total, completedSteps: $0.uploaded)
            }
        }.catch { err in
            print("failed to retrieve current uploads state")
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            print("photo lib authorization: \(status)")
        }
        
        ServicesAssemble.shared.location.askForPermissions()
        
    }
    
    func viewDidDisappear() {
        visible = false
    }
    
    func readProfile() {
        profileProvider.getProfile().done { (profile) in
            print("Profile: \(profile)")
        }.catch { (err) in
            print("Profile read error: \(err)")
        }
    }
    
   
    
    @Published var uploads = [UploadViewState]()
    
    // MARK:- private
    private func addNewUpload(id: Int) {
        uploads = uploads.with(newElement: UploadViewState(id: id, status: "Starting", totalSteps: 0, completedSteps: 0))
    }
    
    private func completeUpload(id: Int) {
        uploads = uploads.removedFirst { $0.id == id }
    }
    
    private func progress(_ p: UploadProgress) {
        uploads = uploads.map {
            if $0.id == p.id {
                return UploadViewState(id: $0.id, status: "In progress", totalSteps: p.total, completedSteps: p.uploaded)
            }
            
            return $0
        }
    }
    
    private let profileProvider: UserProfileProvider
    private let uploadProvider: UploadProvider
    
    private var cancellable: AnyCancellable?
    private var visible = false
}

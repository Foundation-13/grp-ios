import SwiftUI

struct AvatarPickerHost: View {
    
    @ObservedObject var model: AvatarPickerModel
    
    var body: some View {
        VStack {
            if self.model.step == .pick {
                ImagePickerView(delegate: self.model, source: self.model.source)
            } else {
                AvatarCropView(model: self.model)
            }
        }
    }
}

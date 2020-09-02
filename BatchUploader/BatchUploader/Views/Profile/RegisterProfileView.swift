import SwiftUI

struct RegisterProfileView: View {
    @ObservedObject var model: RegisterProfileModel
    @Binding var isActive: Bool
    
    @State private var showAvatarActionSheet = false
    @State private var showAvatarPicker = false
    @State private var avatarSource: UIImagePickerController.SourceType = .photoLibrary
    
    var avatarActionSheet: ActionSheet {
        ActionSheet(title: Text("Use"), buttons: [
            ActionSheet.Button.default(Text("Photo Library")) {
                self.avatarSource = .photoLibrary
                self.showAvatarPicker = true
            },
            ActionSheet.Button.default(Text("Camera"))  {
                self.avatarSource = .camera
                self.showAvatarPicker = true
            }
        ])
    }
    
    var content: some View {
        VStack(alignment: .center) {
            AvatarView(imageRef: self.model.avatar, width: 185, height: 185).onTapGesture {
                self.showAvatarActionSheet = true
            }.padding()
            
            TextField("USERNAME", text: self.$model.name).padding(.horizontal)
            Divider().padding(.horizontal)
            
            Text("HOW OLD?").padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(14..<99, id: \.self) { age in
                        Text("\(age)")
                            .foregroundColor(age == (self.model.age ?? 0) ?
                                Color.primary :
                                Color.secondary)
                            .onTapGesture {
                                self.model.age = age
                            }
                    }
                }
            }.padding(.horizontal)
            
            Spacer()
            
            Button("Register") {
                self.model.registerProfile()
            }
            .padding()
            .disabled(!self.model.isNextAllowed)
            
            Spacer()
            Spacer()
        }
    }
    
    var body: some View {
        LoadingView(isShowing: self.model.isLoading) {
            self.content
        }
        .modifier(AdaptsToSoftwareKeyboard())
        .actionSheet(isPresented: $showAvatarActionSheet) {
            self.avatarActionSheet
        }
        .sheet(isPresented: $showAvatarPicker, onDismiss: {}) {
            AvatarPickerHost(model: AvatarPickerModel(isActive: self.$showAvatarPicker,
                                                      image: self.$model.avatar,
                                                      source: self.avatarSource))
        }
        .alert(isPresented: self.$model.isProfileRegistered) {
            Alert(title: Text("Profile registered"),
                  dismissButton: .default(Text("Close"),
                                          action: { self.isActive = false }))
        }
        .onAppear {
            self.model.viewAppear()
        }.onDisappear {
            self.model.viewDisappear()
        }
    }
}

struct RegisterProfileView_Previews: PreviewProvider {
    static let model = RegisterProfileModel()
    
    static var previews: some View {
        RegisterProfileView(model: model, isActive: .constant(false))
    }
}

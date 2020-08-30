import SwiftUI

struct MainView: View {
    @ObservedObject var model: MainViewModel
    
    @State var openCreateReview = false
    
    var body: some View {
        NavigationView {
            VStack {
                if self.model.uploads.isEmpty {
                    VStack {
                        Text("No active uploads")
                    }.padding(.vertical, 20)
                } else {
                    ScrollView {
                        VStack {
                            ForEach(self.model.uploads) { (upload) in
                                VStack {
                                    Text(upload.name)
                                    ProgressBar(value: .constant(upload.progress))
                                    Divider()
                                }
                            }
                        }
                    }.frame(height: 200)
                }
                
                Button("Create new review") {
                    self.openCreateReview = true
                }
                
                Spacer()
                
                Button("Create profile") {
                    self.model.updateProfile()
                }
                
                Spacer()
                
                Button("Get profile") {
                    self.model.readProfile()
                }
                
                
                NavigationLink(destination: SelectPicturesView(model: SelectPicturesModel(), isActive: self.$openCreateReview),
                               isActive: self.$openCreateReview) {
                    EmptyView()
                }
            }
            .padding()
            .onAppear {
                self.model.viewDidAppear()
            }
            .onDisappear {
                self.model.viewDidDisappear()
            }
        }
    }
}


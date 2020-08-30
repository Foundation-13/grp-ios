import SwiftUI
import PromiseKit

struct SelectPicturesView: View {
    @ObservedObject var model: SelectPicturesModel
    @Binding var isActive: Bool
    
    @State var openPicker = false
    
    var content: some View {
        VStack {
            Group {
                if self.model.selectedImages.isEmpty  {
                    Text("No pictures yet").padding()
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(model.selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20)
            
            Button("Add picture") {
                self.openPicker = true
            }
            .padding(.vertical, 20)
            
            Button("Select place") {
                self.model.getPlaces()
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            NavigationLink(destination: SelectPlaceView(model: model.selectPlaceModel, isActive: self.$isActive),
                           isActive: self.$model.done) {
                EmptyView()
            }.isDetailLink(false)
        }
        .padding(.top, 20)
        .sheet(isPresented: $openPicker, content: {
            ImagePickerView(delegate: self.model)
        })
    }
    
    var body: some View {
        LoadingView(isShowing: model.isLoading){
            self.content
        }.navigationBarTitle("Upload pictures")
    }
}

import SwiftUI

struct SelectPlaceView: View {
    @ObservedObject var model: SelectPlaceModel
    @Binding var isActive: Bool
    
    func imagesLine(_ images: [UIImage]) -> AnyView {
        AnyView(
            ScrollView(.horizontal) {
                HStack {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
            }
        )
    }
    
    func placesList(_ places: [ClusterViewState.PlaceViewState], images: [UIImage]) -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                ForEach(places) { row in
                    NavigationLink(destination: CreateReviewView(model: CreateReviewModel(place: row.place, images: images), isActive: self.$isActive)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(row.name).bold()
                                Text(row.distStr)
                            }
                            Text(row.address)
                            Divider()
                        }
                    }
                    .isDetailLink(false)
                    .buttonStyle(PlainButtonStyle())                    
                }
            }
        )
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ForEach(model.viewState) { row in
                    Text("Found \(row.places.count) candidates for")
                    self.imagesLine(row.images)
                    self.placesList(row.places, images: row.images)
                    Divider()
                    Spacer()
                }
            }
        }.navigationBarTitle("Choose the place")
    
    }
}

struct SelectPlace_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectPlaceView(model: SelectPlaceModel(), isActive: .constant(true))
    }
}

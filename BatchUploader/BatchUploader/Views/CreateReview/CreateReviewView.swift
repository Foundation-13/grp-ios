import SwiftUI
import Combine

struct CreateReviewView: View {
    @ObservedObject var model: CreateReviewModel
    @Binding var isActive: Bool
    
    var content: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 1) {
                Text(model.name)
                Text(model.address)
            }
            
            RatingView(rating: self.$model.rating)
            
            TextInputView("Enter review here", text: self.$model.text)
                .frame(height: 200)
            
            Spacer()
        }
        .padding()
    }
    
    var body: some View {
        LoadingView(isShowing: self.model.isLoading, content: {
            self.content
        })
        .navigationBarTitle("Review for")
        .navigationBarItems(trailing: Button("Send"){
            self.model.createReview()
        })
        .alert(isPresented: self.$model.isReviewCreated) {
            Alert(title: Text("Review created"),
                  message: Text("Review photos are loading in background"),
                  dismissButton: .default(Text("Close"), action: { self.isActive = false }))
        }
    }
}

struct CreateReviewView_Previews: PreviewProvider {
    static let model = CreateReviewModel(place: Places.Place.make(title: "Cool bar", vicinity: "23, Ave, Seattle"))
    
    static var previews: some View {
        CreateReviewView(model: model, isActive: .constant(true))
    }
}

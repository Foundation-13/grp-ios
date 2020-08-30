import SwiftUI

struct SelectPlaceView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
            Button("Move to root") {
                self.isActive = false
            }
        }
    }
}

struct SelectPlace_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectPlaceView(isActive: .constant(true))
    }
}

import SwiftUI
import KingfisherSwiftUI

struct AvatarView: View {
    let imageRef: ImageRef?
    let width: CGFloat
    let height: CGFloat
    
    func image() -> AnyView {
        switch imageRef {
        case .url(let url):
            return AnyView(KFImage(url).placeholder {
                Image("default-avatar").resizable()
            }.resizable())
        case .uiImage(let uiImage):
            return AnyView(Image(uiImage: uiImage).resizable())
        default:
            return AnyView(Image("default-avatar").resizable())
        }
    }
    
    var body: some View {
        image()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}


struct AvatarView_Previews: PreviewProvider {
    static let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzZ2RsB8c0Vmzswaz3g-0iEzPs0Gm7ZyuSHUBl7tzmS9YPfd_H")!
    
    static var previews: some View {
        //AvatarView(imageRef: ImageRef.url(url), width: 185, height: 185)
        AvatarView(imageRef: nil, width: 185, height: 185)
    }
}

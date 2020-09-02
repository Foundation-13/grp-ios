import SwiftUI
import Combine
import UIKit

struct AdaptsToSoftwareKeyboard: ViewModifier {
    
    @State var currentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight).animation(.easeOut(duration: 0.25))
            .edgesIgnoringSafeArea(currentHeight == 0 ? Edge.Set() : .bottom)
            .onAppear(perform: subscribeToKeyboardChanges)
    }
  
    // MARK: - Subscriber to Keyboard's changes
    private func subscribeToKeyboardChanges() {
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
            }.map { rect in
                rect.height
            }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .compactMap { notification in
                CGFloat.zero
            }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    }
    
    private var cancellable: AnyCancellable? = nil
}

struct KeyboardEx {
    static func hide() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}

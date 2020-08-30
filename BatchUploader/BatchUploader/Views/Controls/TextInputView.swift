import SwiftUI

struct TextInputView: View {
    init(_ placeholder: String, text: Binding<String>) {
        self._text = text
        self.placeholder = placeholder
    }
    
    @Binding var text: String
    @State var focused: Bool = false
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            placeholderView
            TextViewWrapper(text: $text, focused: $focused)
        }
    }
    
    var placeholderView: some View {
        ViewBuilder.buildIf(
            showPlaceholder ?
                Text(placeholder)
                    .font(.system(size: 18))
                    .padding(.vertical, 8)
                : nil
        )
    }
    
    var showPlaceholder: Bool {
        !focused && text.isEmpty
    }
}

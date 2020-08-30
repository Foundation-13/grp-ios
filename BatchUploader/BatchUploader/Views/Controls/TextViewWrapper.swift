import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var focused: Bool
    
    // MARK: - UIViewRepresentable
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 18)
        textView.backgroundColor = .clear
        return textView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, focused: $focused)
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        init(text: Binding<String>, focused: Binding<Bool>) {
            self._text = text
            self._focused = focused
        }
        
        @Binding private var text: String
        @Binding private var focused: Bool
        
        // MARK: - UITextViewDelegate
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            focused = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            focused = false
        }
    }
}

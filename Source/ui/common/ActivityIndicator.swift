import SwiftUI
import UIKit
struct ActivityIndicator: UIViewRepresentable {
    @State var isAnimating: Bool

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView()
        v.style = .large
        return v
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if isAnimating {
            uiView.startAnimating()
            uiView.alpha = 1
        } else {
            uiView.stopAnimating()
            uiView.alpha = 0
        }
    }
}

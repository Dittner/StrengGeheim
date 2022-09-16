import SwiftUI

#if os(iOS)
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

#elseif os(OSX)

    struct ActivityIndicator: NSViewRepresentable {
        @State var isAnimating: Bool

        func makeNSView(context: NSViewRepresentableContext<ActivityIndicator>) -> NSProgressIndicator {
            let nsView = NSProgressIndicator()
            nsView.style = .spinning
            return nsView
        }

        func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
            if isAnimating {
                nsView.startAnimation(nil)
                nsView.alphaValue = 1
            } else {
                nsView.stopAnimation(nil)
                nsView.alphaValue = 0
            }
        }
    }

#endif

import SwiftUI
#if os(iOS)

    class Keyboard {
        static func dismiss() {
            UIApplication.shared.endEditing()
        }
    }

    extension UIApplication {
        func endEditing() {
            sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

#elseif os(OSX)
    class Keyboard {
        static func dismiss() {}
    }

#endif

import SwiftUI

extension Color {
    static let SG = SGColors()

    init(rgb: UInt) {
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}

// extension UIColor {
//    convenience init(rgb: UInt, alpha: CGFloat = 1) {
//        self.init(
//            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgb & 0x0000FF) / 255.0,
//            alpha: alpha
//        )
//    }
//
//    var color: Color {
//        Color(self)
//    }
// }

#if os(iOS)

    struct SGColors {
        let tint: Color = Color(rgb: 0x8C85B3)
        let text: Color = Color(rgb: 0xC8C8CF)
        let black: Color = Color(rgb: 0)
        let gray: Color = Color(rgb: 0x828287)
        let dark: Color = Color(rgb: 0x5B5B5E)
        let red: Color = Color(rgb: 0x7F2843)
        let invalid: Color = Color(rgb: 0xCC8888)
        let transparent: Color = Color(rgb: 0).opacity(0.001)
        let navbarBg: Color = Color(rgb: 0x27282e)
        let navbarTitle: Color = Color(rgb: 0xa5a3ad)
        let appBg: Color = Color(rgb: 0x1c1c21)
    }

#elseif os(OSX)
    struct SGColors {
        let tint: Color = Color(rgb: 0x9d99b2)
        let text: Color = Color(rgb: 0xC8C8CF)
        let black: Color = Color(rgb: 0x19191d)
        let gray: Color = Color(rgb: 0x828287)
        let dark: Color = Color(rgb: 0x5B5B5E)
        let red: Color = Color(rgb: 0x7F2843)
        let invalid: Color = Color(rgb: 0xCC8888)
        let transparent: Color = Color(rgb: 0).opacity(0.001)
        let navbarBg: Color = Color(rgb: 0x27282e)
        let navbarTitle: Color = Color(rgb: 0xa5a3ad)
        let appBg: Color = Color(rgb: 0x202126)
    }

    extension NSColor {
        convenience init(rgb: UInt, alpha: CGFloat = 1) {
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: alpha
            )
        }

        public static let SG = (tint: NSColor(rgb: 0x9d99b2, alpha: 1),
                                black: NSColor(rgb: 0x19191d, alpha: 1),
                                text: NSColor(rgb: 0xC8C8CF, alpha: 1))
    }
#endif

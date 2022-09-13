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

extension UIColor {
    convenience init(rgb: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    var color: Color {
        Color(self)
    }
}

struct SGColors {
    let tint: UIColor = UIColor(rgb: 0x877fb5)
    let gray: UIColor = UIColor(rgb: 0x666666)
    let white: UIColor = UIColor(rgb: 0x999999)
    let black: UIColor = UIColor(rgb: 0)
    let red: UIColor = UIColor(rgb: 0x7f2843)
    let invalid: UIColor = UIColor(rgb: 0xcc8888)
    let transparent: UIColor = UIColor(rgb: 0, alpha: 0.001)
    let appBgColor: UIColor = UIColor(rgb: 0x161718)
}

import SwiftUI

enum FontName: String {
    case icons = "icomoon"
    case helveticaNeue = "Helvetica Neue"
    case helveticaThin = "Helvetica Neue Thin"
    case helveticaLight = "Helvetica Neue Light"
    case helveticaNeueBold = "Helvetica Neue Bold"
    case mono = "Menlo-Regular"
    case gothic = "Halja OT"
}

enum FontIcon: String {
    case next = "\u{e903}"
    case prev = "\u{e905}"
    case plus = "\u{e904}"
    case edit = "\u{e902}"
    case apply = "\u{e900}"
    case cancel = "\u{e901}"
}

extension UIFont {
    convenience init(name: FontName, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}

extension Font {
    static func custom(_ name: FontName, size: CGFloat) -> Font {
        Font.custom(name.rawValue, size: size)
    }

    static func printAllSystemFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}


import SwiftUI

enum FontName: String {
    case icons = "BrainCacheIcons"
    case helveticaNeue = "Helvetica Neue"
    case helveticaThin = "Helvetica Neue Thin"
    case helveticaLight = "Helvetica Neue Light"
    case helveticaNeueBold = "Helvetica Neue Bold"
    case mono = "Menlo-Regular"
}

enum FontIcon: String {
    case next = "\u{e900}"
    case prev = "\u{e901}"
    case folder = "\u{e902}"
    case plus = "\u{e903}"
    case table = "\u{e904}"
    case file = "\u{e905}"
    case search = "\u{e906}"
    case close = "\u{e907}"
    case minus = "\u{e908}"
    case list = "\u{e909}"
    case sort = "\u{e90a}"
    case dropdown = "\u{e90b}"
    case arrow = "\u{e90c}"
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


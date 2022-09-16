import SwiftUI

enum FontName: String {
    case icons = "icomoon"
    case helveticaNeue = "Helvetica Neue"
    case helveticaThin = "Helvetica Neue Thin"
    case helveticaLight = "Helvetica Neue Light"
    case helveticaNeueBold = "Helvetica Neue Bold"
    case pragmatica = "PragmaticaBook-Reg"
    case pragmaticaLight = "PragmaticaLight"
    case OpenSansReg = "OpenSans"
    case OpenSansLight = "OpenSans-Light"
    case OpenSansSemibold = "OpenSans-Semibold"
    //case pragmaticaLightItalics = "PragmaticaLight-Oblique"
    //case pragmaticaExtraLight = "PragmaticaExtraLight-Reg"
    //case pragmaticaExtraLightItalics = "PragmaticaExtraLight-Oblique"
    case pragmaticaSemiBold = "PragmaticaMedium"
    case mono = "Menlo-Regular"
    case gothic = "Halja OT"
}

enum FontIcon: String {
    case increase = "\u{e900}"
    case decrease = "\u{e901}"
    case plus = "\u{e902}"
    case prev = "\u{e903}"
    case next = "\u{e904}"
    case cancel = "\u{e905}"
    case apply = "\u{e906}"
}

extension Font {
    static func custom(_ name: FontName, size: CGFloat) -> Font {
        Font.custom(name.rawValue, size: size)
    }

    static func printAllSystemFonts() {
        #if os(iOS)
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Family: \(family) Font names: \(names)")
            }

        #elseif os(OSX)
            for family: String in NSFontManager.shared.availableFontFamilies {
                print("===\(family)===")
                for fontName: String in NSFontManager.shared.availableFonts {
                    print("\(fontName)")
                }
            }
        #endif
    }
}

#if os(iOS)

    extension UIFont {
        convenience init(name: FontName, size: CGFloat) {
            self.init(name: name.rawValue, size: size)!
        }
    }

#elseif os(OSX)

    extension NSFont {
        convenience init(name: FontName, size: CGFloat) {
            self.init(name: name.rawValue, size: size)!
        }
    }

    extension NSTextView {
        static var defaultInsertionPointColor: NSColor {
            return NSColor.controlTextColor
        }

        static var defaultSelectedTextAttributes: [NSAttributedString.Key: Any] {
            return [
                .foregroundColor: NSColor.selectedTextColor,
                .backgroundColor: NSColor.selectedTextBackgroundColor,
            ]
        }
    }

#endif

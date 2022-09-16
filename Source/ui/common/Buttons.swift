import SwiftUI

import SwiftUI

struct Icon: View {
    let name: FontIcon
    let size: CGFloat
    var body: some View {
        Text(name.rawValue)
            .lineLimit(1)
            .font(Font.custom(.icons, size: size))
    }
}

struct IconButton: View {
    var name: FontIcon
    var size: CGFloat
    var iconColor: Color
    var width: CGFloat = 50
    var height: CGFloat = Constants.navigationBarHeight
    let onAction: () -> Void

    @State private var onPressed = false

    var body: some View {
        Icon(name: name, size: size)
            .frame(width: width, height: height)
            .contentShape(Rectangle())
            .foregroundColor(onPressed ? iconColor.opacity(0.5) : iconColor)
            .onTapGesture {
                self.onAction()
            }
            .pressAction {
                self.onPressed = true
            } onRelease: {
                self.onPressed = false
            }
    }
}

struct BlackIconButton: View {
    var name: FontIcon
    var size: CGFloat
    var iconColor: Color
    let onAction: () -> Void

    @State private var onPressed = false

    var body: some View {
        Icon(name: name, size: size)
            .frame(width: 50, height: 50, alignment: .center)
            .contentShape(Rectangle())
            .foregroundColor(iconColor)
            .background(onPressed ? Color.SG.black : Color.SG.navbarBg)
            .cornerRadius(6)
            .onTapGesture {
                self.onAction()
            }
            .pressAction {
                self.onPressed = true
            } onRelease: {
                self.onPressed = false
            }
    }
}

struct TextButton: View {
    var text: LocalizedStringKey
    var textColor: Color
    var font: Font
    var height: CGFloat = 50
    let onAction: () -> Void

    @State private var onPressed = false

    var body: some View {
        Text(text)
            .lineLimit(1)
            .font(font)
            .foregroundColor(onPressed ? textColor.opacity(0.5) : textColor)
            .frame(height: height)
            .onTapGesture {
                self.onAction()
            }
            .pressAction {
                self.onPressed = true
            } onRelease: {
                self.onPressed = false
            }
    }
}

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

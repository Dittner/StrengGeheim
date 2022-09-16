import SwiftUI

extension View {
    func navigationBarLeading(_ width: Binding<CGFloat?>) -> some View {
        return modifier(NavigationBarLeading(navigationBarSideWidth: width))
    }

    func navigationBarTitle(_ width: Binding<CGFloat?>) -> some View {
        return modifier(NavigationBarTitle(navigationBarSideWidth: width))
    }

    func navigationBarTrailing(_ width: Binding<CGFloat?>) -> some View {
        return modifier(NavigationBarTrailing(navigationBarSideWidth: width))
    }
}

struct NavigationBar<Content: View>: View {
    @State private var textMinWidth: CGFloat?
    private let content: (Binding<CGFloat?>) -> Content

    // the @ViewBuilder property wrapper allows use more views in container
    init(@ViewBuilder _ content: @escaping (Binding<CGFloat?>) -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            self.content($textMinWidth)
                .frame(maxWidth: .infinity, maxHeight: Constants.navigationBarHeight)

        }
        .frame(maxWidth: .infinity, maxHeight: Constants.navigationBarHeight)
        .background(NavigationBarBG()
                        .cornerRadius(20)
                        .edgesIgnoringSafeArea(.top))
        .frame(maxWidth: .infinity, maxHeight: Constants.navigationBarHeight)
        .zIndex(2)
    }
}

struct NavigationBarBG: View {
    var body: some View {
        Color.SG.navbarBg
    }
}

struct NavigationBarSideWidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct NavigationBarLeading: ViewModifier {
    let navigationBarSideWidth: Binding<CGFloat?>

    func body(content: Content) -> some View {
        HStack {
            content
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: NavigationBarSideWidthPreferenceKey.self, value: proxy.size.width)
                }).onPreferenceChange(NavigationBarSideWidthPreferenceKey.self) { value in
                    self.navigationBarSideWidth.wrappedValue = max(self.navigationBarSideWidth.wrappedValue ?? 0, value)
                }
            Spacer()
        }
    }
}

struct NavigationBarTrailing: ViewModifier {
    let navigationBarSideWidth: Binding<CGFloat?>

    func body(content: Content) -> some View {
        HStack {
            Spacer()

            content
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: NavigationBarSideWidthPreferenceKey.self, value: proxy.size.width)
                }).onPreferenceChange(NavigationBarSideWidthPreferenceKey.self) { value in
                    self.navigationBarSideWidth.wrappedValue = max(self.navigationBarSideWidth.wrappedValue ?? 0, value)
                }
        }
    }
}

struct NavigationBarTitle: ViewModifier {
    let navigationBarSideWidth: Binding<CGFloat?>

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, navigationBarSideWidth.wrappedValue)
            .frame(maxWidth: .infinity)
    }
}

struct NavigationBarShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.1), radius: 0, x: 0, y: 0.5)
    }
}

extension View {
    func navigationBarShadow() -> some View {
        ModifiedContent(content: self, modifier: NavigationBarShadow())
    }
}

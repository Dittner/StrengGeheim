import Combine
import SwiftUI

enum ScreenID: String {
    case login
    case index
    case cardList
    case cardEdit
}

struct ScreenPosition {
    let leading: ScreenID?
    let center: ScreenID
    let trailing: ScreenID?
    let goBack: Bool

    func xPosition(id: ScreenID) -> CGFloat? {
        if let leadingScreenID = leading, leadingScreenID == id {
            return -1
        } else if center == id {
            return 0
        } else if let trailingScreenID = trailing, trailingScreenID == id {
            return 1
        } else {
            return nil
        }
    }
}

struct Screen {
    let activated: ScreenID
    let deactivated: ScreenID?
}

class Navigator: ObservableObject {
    static var shared = Navigator()
    
    @Published var screenPosition: ScreenPosition
    @Published var screen: Screen

    init() {
        screen = Screen(activated: .login, deactivated: nil)
        screenPosition = ScreenPosition(leading: nil, center: .login, trailing: nil, goBack: false)
    }

    func goBack(to: ScreenID) {
        screen = Screen(activated: to, deactivated: screen.activated)
        withAnimation {
            screenPosition = ScreenPosition(leading: nil, center: to, trailing: screenPosition.center, goBack: true)
        }
    }

    func navigate(to: ScreenID) {
        screen = Screen(activated: to, deactivated: screen.activated)
        withAnimation {
            screenPosition = ScreenPosition(leading: screenPosition.center, center: to, trailing: nil, goBack: false)
        }
    }
}

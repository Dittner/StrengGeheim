import Combine
import SwiftUI

class AppEventDispatcher {
    let subject = PassthroughSubject<AppEvent, Never>()
    func notify(_ event: AppEvent) {
        subject.send(event)
    }
}

enum AppEvent {
    case appDeactivated
    case appActivated
}


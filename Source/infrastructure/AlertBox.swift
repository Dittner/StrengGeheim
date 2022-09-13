import Combine
import SwiftUI

class AlertBox: ObservableObject {
    static var shared = AlertBox()

    @Published var message: AlertMessage? = nil

    func show(title: LocalizedStringKey, details: LocalizedStringKey) {
        if message == nil {
            message = AlertMessage(title: title, details: details)
        }
    }
}

struct AlertMessage: Identifiable {
    let id = UID()
    let title: LocalizedStringKey
    let details: LocalizedStringKey
}

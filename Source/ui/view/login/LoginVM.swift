import Combine
import SwiftUI

class LoginVM: ViewModel, ObservableObject {
    static var shared: LoginVM = LoginVM(id: .login)

    @Published var isLoading: Bool = false
    @Published var errorMsg: String = ""
    
    override init(id: ScreenID) {
        logInfo(msg: "LoginVM init")
        super.init(id: id)
    }

    func login() {
        if user.login() {
            errorMsg = ""
            user.password = ""
            Keyboard.dismiss()
            navigator.navigate(to: .index)
        } else {
            errorMsg = "Der Schlüssel ist ungültig"
        }
    }
}

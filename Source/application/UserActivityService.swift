import Combine
import SwiftUI

class UserActivityService {
    private let user: User
    private let navigator: Navigator
    private let appEventDispatcher: AppEventDispatcher

    private let MAX_TIME_OF_INACTIVITY_IN_SEC:Int = 5 * 60 
    private var timer: DispatchSourceTimer?
    private var disposeBag: Set<AnyCancellable> = []
    init(dispatcher: AppEventDispatcher, user: User, navigator: Navigator) {
        appEventDispatcher = dispatcher
        self.user = user
        self.navigator = navigator
        dispatcher.subject
            // .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { event in
                switch event {
                case .appDeactivated:
                    if self.timer == nil {
                        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
                        self.timer?.schedule(deadline: .now() + .seconds(self.MAX_TIME_OF_INACTIVITY_IN_SEC))
                        self.timer?.setEventHandler {
                            self.logout()
                        }
                        self.timer?.resume()
                    }
                case .appActivated:
                    if self.timer != nil {
                        self.timer?.cancel()
                        self.timer = nil
                    }
                }
            }
            .store(in: &disposeBag)
    }
    
    private func logout() {
        logInfo(msg: "Time out of inactivity, user has been forced to log out.")
        self.user.logout()
        self.navigator.navigate(to: .login)
    }
}

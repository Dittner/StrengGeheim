import Combine

class ViewModel {
    private(set) var screenID: ScreenID
    private(set) var navigator: Navigator
    @Published var user: User
    private(set) var repo: IIndexRepository
    private(set) var dispatcher: DomainEventDispatcher
    private var navigatorSubscription: AnyCancellable?

    init(id: ScreenID) {
        screenID = id
        navigator = Navigator.shared
        user = SGContext.shared.user
        repo = SGContext.shared.repo
        dispatcher = SGContext.shared.domainEventDispatcher
        
        navigatorSubscription = navigator.$screen
            .sink { screen in
                if screen.deactivated == self.screenID {
                    self.screenDeactivated()
                } else if screen.activated == self.screenID {
                    self.screenActivated()
                }
            }
    }

    func screenActivated() {
        logInfo(msg: "\(screenID.rawValue) screen has been activated")
    }

    func screenDeactivated() {
        logInfo(msg: "\(screenID.rawValue) screen has been deactivated")
    }
}

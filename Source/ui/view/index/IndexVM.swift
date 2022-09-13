import Combine
import SwiftUI

class IndexVM: ViewModel, ObservableObject {
    static var shared: IndexVM = IndexVM(id: .index)
    let indexIDs: [CardIndexID]

    private var disposeBag: Set<AnyCancellable> = []
    override init(id: ScreenID) {
        logInfo(msg: "IndexVM init")
        indexIDs = CardIndexID.allCases
        super.init(id: id)
    }

    func openIndex(_ id: CardIndexID) {
        user.selectedIndexID = id
        navigator.navigate(to: .cardList)
    }

    func goBack() {
        user.logout()
        navigator.goBack(to: .login)
    }
}

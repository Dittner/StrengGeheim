import Combine
import SwiftUI

class CardEditVM: ViewModel, ObservableObject {
    static var shared = CardEditVM(id: .cardEdit)
    @Published var title: String = ""
    @Published var text: String = ""

    private var disposeBag: Set<AnyCancellable> = []
    override init(id: ScreenID) {
        logInfo(msg: "CardEditVM init")
        super.init(id: id)

        user.$selectedCard
            .sink { card in
                self.title = card?.title ?? ""
                self.text = card?.text ?? ""
            }
            .store(in: &disposeBag)
    }

    func cancel() {
        user.selectedCard = nil
        navigator.goBack(to: .cardList)
    }

    func apply() {
        if let selectedCard = user.selectedCard {
            selectedCard.title = title
            selectedCard.text = text
            logInfo(msg: "title=" + title + ", text=" + text)
        }
        Keyboard.dismiss()
        user.selectedCard = nil
        navigator.goBack(to: .cardList)
    }
}

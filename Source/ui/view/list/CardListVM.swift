import Combine
import SwiftUI

class CardListVM: ViewModel, ObservableObject {
    static var shared = CardListVM(id: .cardList)
    @Published private(set) var title: String = ""
    @Published private(set) var cards: [Card] = []
    @Published private(set) var isLoading: Bool = true

    private var disposeBag: Set<AnyCancellable> = []
    override init(id: ScreenID) {
        logInfo(msg: "CardListVM init")
        super.init(id: id)
    }

    var loadCardsPublisher: AnyCancellable?
    override func screenActivated() {
        super.screenActivated()
        isLoading = true
        cards = []

        guard let indexID = user.selectedIndexID else { return }

        title = indexID.getTitle()

        loadCardsPublisher = repo.read(indexID)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Async.after(milliseconds: 500) {
                        self.isLoading = false
                    }
                    break
                case let .failure(anError):
                    AlertBox.shared.show(title: "Repository", details: anError.localizedDescription)
                    logErr(msg: anError.localizedDescription)
                    break
                }
            }, receiveValue: { cardIndex in
                if let cardIndex = cardIndex {
                    self.user.selectedIndex = cardIndex
                    self.cards = cardIndex.cards.filter { $0.text != "" }
                } else {
                    let newIndex = CardIndex.create(id: indexID)
                    self.user.selectedIndex = newIndex
                }
            })
    }

    func editCard(_ card: Card) {
        user.selectedCard = card
        navigator.navigate(to: .cardEdit)
    }

    func goBack() {
        user.selectedIndex = nil
        user.selectedCard = nil
        navigator.goBack(to: .index)
    }

    func createCard() {
        if let selectedIndex = self.user.selectedIndex {
            user.selectedCard = selectedIndex.addNewCard()
            navigator.navigate(to: .cardEdit)
        }
    }
}

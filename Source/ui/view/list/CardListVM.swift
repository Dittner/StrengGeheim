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
        logInfo(msg: "CardListVM screenActivated")
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
                    self.title = "Wegen eines Fehlers sind Previews nicht verfügbar"
                    logErr(msg: anError.localizedDescription)
                    break
                }
            }, receiveValue: { cardIndex in
                self.user.selectedIndex = cardIndex
                self.cards = cardIndex.cards.filter { $0.text != "" }
            })
    }

    func editCard(_ card: Card) {
        user.selectedCard = card
        navigator.navigate(to: .cardEdit)
    }

    func goBack() {
        self.user.selectedIndex = nil
        user.selectedCard = nil
        navigator.goBack(to: .index)
    }
    
    func createCard() {
        user.selectedCard = nil
        navigator.navigate(to: .cardEdit)
    }
}

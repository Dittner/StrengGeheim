import Combine
import SwiftUI

class CardEditVM: ViewModel, ObservableObject {
    static var shared = CardEditVM(id: .cardEdit)
    @Published var title: String = ""
    @Published var text: String = ""
    @Published var cardPos: Int = 0
    @Published var showAlert: Bool = false
    private var originalCardPos: Int = 0
    private var cardIndex: CardIndex?

    private var disposeBag: Set<AnyCancellable> = []
    override init(id: ScreenID) {
        logInfo(msg: "CardEditVM init")
        super.init(id: id)

        user.$selectedCard
            .sink { card in
                self.updateCardInfo(card)
            }
            .store(in: &disposeBag)
    }

    func updateCardInfo(_ card: Card?) {
        if let c = card {
            cardIndex = c.index
            title = c.title
            text = c.text
            for i in c.index.cards.indices {
                if c.uid == c.index.cards[i].uid {
                    cardPos = i
                    originalCardPos = i
                    break
                }
            }
        } else {
            title = ""
            text = ""
            cardPos = 0
            originalCardPos = 0
            cardIndex = nil
        }
    }

    func apply() {
        if let selectedCard = user.selectedCard {
            selectedCard.title = title
            selectedCard.text = text
            if originalCardPos != cardPos {
                selectedCard.index.moveCard(selectedCard, to: cardPos)
            }
        }
        goBack()
    }

    func incCardPosition() {
        guard let cardIndex = cardIndex else { return }
        if cardPos < cardIndex.cards.count - 1 {
            cardPos += 1
        }
    }

    func decCardPosition() {
        if cardPos > 0 {
            cardPos -= 1
        }
    }

    func removeCard() {
        guard let selectedCard = user.selectedCard, let cardIndex = cardIndex else { return }
        if showAlert {
            cardIndex.removeCard(selectedCard)
            goBack()
        } else {
            showAlert = true
        }
    }

    func cancelRemove() {
        showAlert = false
    }

    func goBack() {
        user.selectedCard = nil
        showAlert = false
        navigator.goBack(to: .cardList)
    }
}

import Combine
import SwiftUI

class User: ObservableObject {
    var selectedIndexID: CardIndexID?
    @Published var selectedCard: Card?
    @Published var selectedIndex: CardIndex?
    @Published var password: String = ""

    fileprivate var encryptedPwd: String = ""
    var isLoggedIn: Bool = false

    init() {
        if let encryptedPwd = UserDefaults.standard.string(forKey: "sgEncryptedPwd") {
            self.encryptedPwd = encryptedPwd
        }
    }

    func login() -> Bool {
        if encryptedPwd.count == 0 {
            UserDefaults.standard.set(encryptPwd(password), forKey: "sgEncryptedPwd")
            isLoggedIn = true
            return true
        } else {
            return encryptPwd(password) == encryptedPwd
        }
    }

    func logout() {
        password = ""
        selectedCard = nil
        selectedIndex = nil
        selectedIndexID = nil
        isLoggedIn = false
    }

    private func encryptPwd(_ pwd: String) -> String {
        return ("SG" + pwd).sha512()!
    }
}

enum CardIndexID: String, Codable, CaseIterable {
    case bank
    case personal
    case mail
    case website
    case todo
    case schedule

    static var allCases: [CardIndexID] {
        return [.bank, .personal, .mail, .website, .todo, .schedule]
    }

    func getTitle() -> String {
        switch self {
        case .bank: return "Bankverbindungen"
        case .personal: return "Persönliche Daten"
        case .mail: return "E-Mails"
        case .website: return "Webseiten"
        case .todo: return "ToDo"
        case .schedule: return "Termine"
        }
    }
}

class CardIndex: ObservableObject, Identifiable {
    let id: CardIndexID
    let dispatcher: DomainEventDispatcher
    @Published private(set) var cards: [Card]

    static func create(id: CardIndexID) -> CardIndex {
        return CardIndex(id: id, cards: [], dispatcher: SGContext.shared.domainEventDispatcher)
    }

    init(id: CardIndexID, cards: [Card], dispatcher: DomainEventDispatcher) {
        self.id = id
        self.cards = cards
        self.dispatcher = dispatcher

        cards.forEach { card in card.index = self }
    }

    func addNewCard() -> Card {
        let c = Card(uid: UID(), title: "", text: "", dispatcher: dispatcher)
        c.index = self
        cards.insert(c, at: 0)
        return c
    }
    
    func removeCard(_ card: Card) {
        for i in self.cards.indices {
            if card.uid == cards[i].uid {
                self.cards.remove(at: i)
                self.dispatcher.notify(.indexStateChanged(index: self))
                break
            }
        }
    }
    
    func moveCard(_ card:Card, to: Int) {
        for i in self.cards.indices {
            if card.uid == cards[i].uid {
                self.cards.remove(at: i)
                self.cards.insert(card, at: to)
                self.dispatcher.notify(.indexStateChanged(index: self))
                break
            }
        }
    }
}

class Card: ObservableObject {
    let uid: UID
    fileprivate(set) var index: CardIndex!
    let dispatcher: DomainEventDispatcher
    @Published var title: String = ""
    @Published var text: String = ""

    init(uid: UID, title: String, text: String, dispatcher: DomainEventDispatcher) {
        self.uid = uid
        self.title = title
        self.text = text
        self.dispatcher = dispatcher

        notifyStateChanged()
    }

    private var disposeBag: Set<AnyCancellable> = []
    private func notifyStateChanged() {
        $title
            .removeDuplicates()
            .dropFirst()
            .sink { _ in
                self.dispatcher.notify(.indexStateChanged(index: self.index))
            }
            .store(in: &disposeBag)
        
        $text
            .removeDuplicates()
            .dropFirst()
            .sink { _ in
                self.dispatcher.notify(.indexStateChanged(index: self.index))
            }
            .store(in: &disposeBag)
    }
}

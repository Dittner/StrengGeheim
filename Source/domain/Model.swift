import Combine
import SwiftUI

class User: ObservableObject {
    var selectedIndexID: CardIndexID?
    var selectedCard: Card?
    var selectedIndex: CardIndex?
    @Published var password: String = "4561"

    fileprivate var encryptedPwd: String = ""
    var isLoggedIn: Bool = false

    init() {
        if let encryptedPwd = UserDefaults.standard.string(forKey: "sgEncryptedPwd") {
            self.encryptedPwd = encryptedPwd
        }
    }

    func login() -> Bool {
        if self.encryptedPwd.count == 0 {
            UserDefaults.standard.set(encryptPwd(password), forKey: "sgEncryptedPwd")
            isLoggedIn = true
            logInfo(msg: "store encryptPwd(password)=" + encryptPwd(password))
            return true
        } else {
            logInfo(msg: "encryptPwd(password)=" + encryptPwd(password))
            logInfo(msg: "encryptedPwd=" + self.encryptedPwd)
            logInfo(msg: "Pwd=" + password)
            return encryptPwd(password) == self.encryptedPwd
        }
    }

    func logout() {
        password = ""
        isLoggedIn = false
    }

    private func encryptPwd(_ pwd: String) -> String {
        return ("SG" + pwd).sha512()!
    }
}

enum CardIndexID: Int, Codable, CaseIterable {
    case bank = 0
    case mail
    case password
    case todo
    case schedule

    static var allCases: [CardIndexID] {
        return [.bank, .mail, .password, .todo, .schedule]
    }

    func getTitle() -> String {
        switch self {
        case .bank: return "Bankverbindungen"
        case .mail: return "E-Mails"
        case .password: return "Schlüssel"
        case .todo: return "ToDo"
        case .schedule: return "Termine"
        }
    }
}

class CardIndex: ObservableObject {
    let id: CardIndexID
    @Published private(set) var cards: [Card]

    init(id: CardIndexID, cards: [Card]) {
        self.id = id
        self.cards = cards
    }
}

class Card: ObservableObject {
    let uid: UID
    @Published var text: String = ""

    init(uid: UID, text: String) {
        self.uid = uid
        self.text = text
    }
}

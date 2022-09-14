import Foundation

enum CardSerializerError: DetailedError {
    case invalidCardDTO(details: String)
}

struct CardDTO: Codable {
    var uid: UID
    var title: String
    var text: String
}

class CardSerializer {
    let dispatcher: DomainEventDispatcher

    init(dispatcher: DomainEventDispatcher) {
        self.dispatcher = dispatcher
    }

    func serialize(_ c: Card) -> CardDTO {
        return CardDTO(uid: c.uid, title: c.title, text: c.text)
    }

    func deserialize(dto: CardDTO) throws -> Card {
        return Card(uid: dto.uid, title: dto.title, text: dto.text, dispatcher: dispatcher)
    }
}

import Foundation

enum IndexSerializerError: DetailedError {
    case invalidIndexDTO(details: String)
}

struct IndexDTO: Codable {
    var id: CardIndexID
    var cards: [CardDTO]
}

class IndexSerializer: IIndexSerializer {
    private let cardSerializer: CardSerializer
    private let dispatcher: DomainEventDispatcher
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(dispatcher: DomainEventDispatcher) {
        cardSerializer = CardSerializer(dispatcher: dispatcher)
        self.dispatcher = dispatcher
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }

    func serialize(_ index: CardIndex) throws -> Data {
        var cards: [CardDTO] = []
        for c in index.cards.filter({ $0.text != "" }) {
            cards.append(cardSerializer.serialize(c))
        }

        let dto = IndexDTO(id: index.id, cards: cards)

        return try encoder.encode(dto)
    }

    func deserialize(data: Data) throws -> CardIndex {
        let dto = try decoder.decode(IndexDTO.self, from: data)
        let cards = try readCards(cards: dto.cards)

        return CardIndex(id: dto.id, cards: cards, dispatcher: dispatcher)
    }

    func readCards(cards: [CardDTO]) throws -> [Card] {
        var res: [Card] = []
        for dto in cards {
            try res.append(cardSerializer.deserialize(dto: dto))
        }

        return res
    }
}

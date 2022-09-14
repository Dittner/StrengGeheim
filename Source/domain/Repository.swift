import Combine
import Foundation

protocol IIndexRepository {
    func read(_ id: CardIndexID) -> AnyPublisher<CardIndex?, CardIndexRepositoryError>
}

protocol IIndexSerializer {
    func serialize(_ index: CardIndex) throws -> Data
    func deserialize(data: Data) throws -> CardIndex
}

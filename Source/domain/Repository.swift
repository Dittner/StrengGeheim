import Combine
import Foundation

protocol IIndexRepository {
    func read(_ id: CardIndexID) -> AnyPublisher<CardIndex?, CardIndexRepositoryError>
    func applyCryptor(_ cryptor: Cryptor)
}

protocol Cryptor {
    func encrypt(_ src: Data) throws -> Data
    func decrypt(_ encryptedData: Data) throws -> Data
}

protocol IIndexSerializer {
    func serialize(_ index: CardIndex) throws -> Data
    func deserialize(data: Data) throws -> CardIndex
}

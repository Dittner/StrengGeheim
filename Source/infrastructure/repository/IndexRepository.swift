import Combine
import Foundation

enum CardIndexRepositoryError: DetailedError {
    case createStorageDirFailed(details: String)
    case readIndexFromDiscFailed(details: String)
    case jsonDeserializationFailed(path: String, details: String)
}

class CardIndexRepository: IIndexRepository {
    private let url: URL
    private var hash: [CardIndexID: CardIndex] = [:]
    private let serializer: IIndexSerializer
    private let dispatcher: DomainEventDispatcher
    private(set) var isReady: Bool = false

    init(serializer: IIndexSerializer, dispatcher: DomainEventDispatcher, storeTo: URL) {
        logInfo(msg: "CardIndexRepository init, url: \(storeTo)")
        self.serializer = serializer

        self.dispatcher = dispatcher
        url = storeTo

        createStorageIfNeeded()
        subscribeToDispatcher()
    }

    private func createStorageIfNeeded() {
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                logErr(msg: CardIndexRepositoryError.createStorageDirFailed(details: error.localizedDescription).localizedDescription)
            }
        }
    }

    private var disposeBag: Set<AnyCancellable> = []
    private func subscribeToDispatcher() {
        dispatcher.subject
            .sink { event in
                switch event {
                case let .indexStateChanged(index):
                    self.store(index)
                }
            }
            .store(in: &disposeBag)
    }

    func getIndexStoreURL(_ id: CardIndexID) -> URL {
        return url.appendingPathComponent(id.rawValue.description + ".sg")
    }

    func read(_ id: CardIndexID) -> AnyPublisher<CardIndex, CardIndexRepositoryError> {
        logInfo(msg: "repo.read, cardIndexID=" + id.rawValue.description)
        let p = Future<CardIndex, CardIndexRepositoryError> { promise in

            if let res = self.hash[id] {
                logInfo(msg: "hash has a cardIndex")
                promise(.success(res))
            } else if FileManager.default.fileExists(atPath: self.getIndexStoreURL(id).path) {
                let fileURL = self.getIndexStoreURL(id)
                logInfo(msg: "loading cardIndex...")
                do {
                    let data = try Data(contentsOf: fileURL)
                    let res = try self.serializer.deserialize(data: data)
                    self.hash[id] = res
                    promise(.success(res))
                } catch {
                    let errDetails = "Failed to deserialize a book, url: \(fileURL), details: \(error.localizedDescription)"
                    let err = CardIndexRepositoryError.jsonDeserializationFailed(path: fileURL.path, details: errDetails)
                    // logErr(msg: errDetails)
                    promise(.failure(err))
                }
            } else {
                logInfo(msg: "Create new CardIndex")
                let res = CardIndex(id: id, cards: [])
                self.hash[id] = res
                promise(.success(res))
            }
        }
        return p.eraseToAnyPublisher()
    }

    private func store(_ index: CardIndex) {
        DispatchQueue.global(qos: .utility).sync {
            do {
                let fileUrl = self.getIndexStoreURL(index.id)
                let data = try self.serializer.serialize(index)
                do {
                    try data.write(to: fileUrl)
                } catch {
                    logErr(msg: "Failed to write index with id=\(index.id.rawValue.description) on disc, details:  \(error.localizedDescription)")
                }
            } catch {
                logErr(msg: "Failed to serialize index with id=\(index.id.rawValue.description), details:  \(error.localizedDescription)")
            }
        }
    }
}

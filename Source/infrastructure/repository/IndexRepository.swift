import Combine
import Foundation

enum CardIndexRepositoryError: DetailedError {
    case createStorageDirFailed(details: String)
    case readIndexFromDiscFailed(details: String)
    case jsonDeserializationFailed(path: String, details: String)
    case encryptionDataFailed(path: String, details: String)
}

class CardIndexRepository: IIndexRepository {
    private let url: URL
    private var hash: [CardIndexID: CardIndex] = [:]
    private let serializer: IIndexSerializer
    private let dispatcher: DomainEventDispatcher
    private var cryptor: Cryptor?

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
            // .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { event in
                switch event {
                case let .indexStateChanged(index):
                    self.hash[index.id] = index
                    self.pendingIndicesToStore.append(index.id)
                    self.storeChanges()
                }
            }
            .store(in: &disposeBag)
    }

    func getIndexStoreURL(_ id: CardIndexID) -> URL {
        return url.appendingPathComponent(id.rawValue.description + ".sg")
    }

    func applyCryptor(_ cryptor: Cryptor) {
        self.cryptor = cryptor
    }

    func read(_ id: CardIndexID) -> AnyPublisher<CardIndex?, CardIndexRepositoryError> {
        logInfo(msg: "repo.read, cardIndexID=" + id.rawValue.description)
        let p = Future<CardIndex?, CardIndexRepositoryError> { promise in

            if let res = self.hash[id] {
                logInfo(msg: "Repo: the hash has the cardIndex")
                promise(.success(res))
            } else if FileManager.default.fileExists(atPath: self.getIndexStoreURL(id).path) {
                let fileURL = self.getIndexStoreURL(id)
                logInfo(msg: "Repo: loading the cardIndex...")
                do {
                    let encryptedData = try Data(contentsOf: fileURL)
                    do {
                        let data = try self.cryptor?.decrypt(encryptedData) ?? encryptedData
                        let res = try self.serializer.deserialize(data: data)
                        self.hash[id] = res
                        promise(.success(res))

                    } catch {
                        let errDetails = "Repo: encryption data is failed: \(error.localizedDescription)"
                        let err = CardIndexRepositoryError.encryptionDataFailed(path: fileURL.path, details: errDetails)
                        promise(.failure(err))
                    }
                } catch {
                    let errDetails = "Failed to deserialize an index with id: \(id), details: \(error.localizedDescription)"
                    let err = CardIndexRepositoryError.jsonDeserializationFailed(path: fileURL.path, details: errDetails)
                    // logErr(msg: errDetails)
                    promise(.failure(err))
                }
            } else {
                logInfo(msg: "Repo: CardIndex with id=\(id) does not exist")
                promise(.success(nil))
            }
        }
        return p.eraseToAnyPublisher()
    }

    private var pendingIndicesToStore: [CardIndexID] = []
    private func storeChanges() {
        Async.after(milliseconds: 1000) {
            for indexID in self.pendingIndicesToStore.removeDuplicates() {
                if let index = self.hash[indexID] {
                    self.store(index)
                }
            }
            self.pendingIndicesToStore = []
        }
    }

    private func store(_ index: CardIndex) {
        DispatchQueue.global(qos: .utility).sync {
            do {
                let fileUrl = self.getIndexStoreURL(index.id)
                var data = try self.serializer.serialize(index)
                if let cryptor = cryptor {
                    data = try cryptor.encrypt(data)
                }

                do {
                    try data.write(to: fileUrl)
                    logInfo(msg: "Repo: index with id=\(index.id.rawValue) has been successfully stored")
                } catch {
                    logErr(msg: "Repo: Failed to write index with id=\(index.id.rawValue) on disc, details:  \(error.localizedDescription)")
                }
            } catch {
                logErr(msg: "Repo: Failed to serialize index with id=\(index.id.rawValue), details:  \(error.localizedDescription)")
            }
        }
    }
}

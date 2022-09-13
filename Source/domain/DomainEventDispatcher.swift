import Combine
import SwiftUI

class DomainEventDispatcher {
    let subject = PassthroughSubject<DomainEvent, Never>()
    func notify(_ event: DomainEvent) {
        subject.send(event)
    }
}

enum DomainEvent {
    case indexStateChanged(index: CardIndex)
}


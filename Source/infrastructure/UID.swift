import Foundation
typealias UID = Int64

extension UID {
    private static var ids:UID = UID(Date().timeIntervalSinceReferenceDate)

    init() {
        UID.ids += 1
        self = UID.ids
    }
}

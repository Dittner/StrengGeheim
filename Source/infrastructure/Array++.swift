import Foundation

extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        return Array(Set(self))
    }
}

extension Array where Element: Identifiable {
    func getFirstIndexOf(item: Element) -> Int? {
        for (index, e) in enumerated() {
            if e.id == item.id {
                return index
            }
        }
        return nil
    }
}

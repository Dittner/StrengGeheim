import Foundation

extension TimeInterval {
    var seconds: Int {
        return Int(rounded())
    }

    var milliseconds: Int {
        return Int(self * 1000)
    }
}

import Foundation
protocol DetailedError: LocalizedError {
}

extension DetailedError {
    var errorDescription: String? { return "Error: \(self)" }
}

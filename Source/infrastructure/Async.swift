import Foundation

typealias Async = DispatchQueue

extension Async {
    static func background(_ task: @escaping () -> Void) {
        Async.global(qos: .background).async {
            task()
        }
    }

    static func background(_ task: @escaping () throws -> Void, completion: @escaping (Error?) -> Void) {
        Async.global(qos: .background).async {
            do {
                try task()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    static func main(_ task: @escaping () -> Void) {
        Async.main.async {
            task()
        }
    }
    
    static func after(milliseconds: Int, _ task: @escaping () -> Void) {
        Async.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(milliseconds), execute: task)
    }
    
}

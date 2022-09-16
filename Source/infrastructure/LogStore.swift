import Foundation

#if os(iOS)
import os.log

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SG")

func logInfo(msg: String) {
    logger.info("\(msg)")
}

func logWarn(msg: String) {
    logger.warning("\(msg)")
}

func logErr(msg: String) {
    logger.error("\(msg)")
}

#elseif os(OSX)

func logInfo(msg: String) {
    print(msg)
}

func logWarn(msg: String) {
    print("Warning: \(msg)")
}

func logErr(msg: String) {
    print("Error: \(msg)")
}

#endif

import Combine
import Foundation
import SwiftUI

#if os(iOS)
    import UIKit
#endif

class SGContext {
    static var shared: SGContext = SGContext()
    private(set) var user: User
    private(set) var repo: IIndexRepository
    private(set) var dispatcher: DomainEventDispatcher

    init() {
        SGContext.logAbout()
        logInfo(msg: "SharedContext initialized")
        user = User()
        dispatcher = DomainEventDispatcher()
        
        #if os(iOS)

        repo = CardIndexRepository(serializer: IndexSerializer(dispatcher: dispatcher),
                                   dispatcher: dispatcher,
                                   storeTo: URLS.documentsURL.appendingPathComponent("Index"))
        #elseif os(OSX)
        repo = CardIndexRepository(serializer: IndexSerializer(dispatcher: dispatcher),
                                   dispatcher: dispatcher,
                                   storeTo: URLS.documentsURL.appendingPathComponent("StrengGeheim/Index"))
        #endif
    }

    private static func logAbout() {
        var aboutLog: String = "StrengGeheimLogs\n"
        #if os(iOS)
            let ver: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
            let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
            aboutLog += "v." + ver + "." + build + "\n"

            let device = UIDevice.current
            aboutLog += "simulator: " + device.isSimulator.description + "\n"
            aboutLog += "device: " + device.modelName + "\n"
            aboutLog += "os: " + device.systemName + " " + device.systemVersion + "\n"

        #elseif os(OSX)

            let home = FileManager.default.homeDirectoryForCurrentUser
            aboutLog += "home dir = \(home.description)"

        #endif

        #if DEBUG
            aboutLog += "debug mode\n"
            aboutLog += "docs folder: \\" + URLS.documentsURL.description
        #else
            aboutLog += "release mode\n"
        #endif

        logInfo(msg: aboutLog)
    }

    func run() {}
}

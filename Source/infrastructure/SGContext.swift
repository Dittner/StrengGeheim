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
    private(set) var domainEventDispatcher: DomainEventDispatcher
    private(set) var appEventDispatcher: AppEventDispatcher
    private(set) var userActivityService: UserActivityService

    init() {
        SGContext.logAbout()
        logInfo(msg: "SharedContext initialized")
        user = User()
        domainEventDispatcher = DomainEventDispatcher()
        appEventDispatcher = AppEventDispatcher()
        userActivityService = UserActivityService(dispatcher: appEventDispatcher, user: user, navigator: Navigator.shared)

        #if os(iOS)

        repo = CardIndexRepository(serializer: IndexSerializer(dispatcher: domainEventDispatcher),
                                   dispatcher: domainEventDispatcher,
                                       storeTo: URLS.documentsURL.appendingPathComponent("Index"))
        #elseif os(OSX)
            repo = CardIndexRepository(serializer: IndexSerializer(dispatcher: domainEventDispatcher),
                                       dispatcher: domainEventDispatcher,
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

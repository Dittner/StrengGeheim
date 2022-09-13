//
//  SGContext.swift
//  StrengGeheim
//
//  Created by Alexander Dittner on 01.03.2021.
//

import UIKit
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
        repo = CardIndexRepository(serializer: IndexSerializer(dispatcher: dispatcher),
                                   dispatcher: dispatcher,
                                   storeTo: URLS.documentsURL)
    }
    
    private static func logAbout() {
        var aboutLog: String = "StrengGeheimLogs\n"
        let ver: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        aboutLog += "v." + ver + "." + build + "\n"

        let device = UIDevice.current
        aboutLog += "simulator: " + device.isSimulator.description + "\n"
        aboutLog += "device: " + device.modelName + "\n"
        aboutLog += "os: " + device.systemName + " " + device.systemVersion + "\n"
        #if DEBUG
            aboutLog += "debug mode\n"
            aboutLog += "docs folder: \\" + URLS.documentsURL.description
        #else
            aboutLog += "release mode\n"
        #endif

        logInfo(msg: aboutLog)
    }
}

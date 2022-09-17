//
//  StrengGeheimApp.swift
//  StrengGeheim
//
//  Created by Alexander Dittner on 12.09.2022.
//

import SwiftUI

@main
struct StrengGeheimApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentViewIOS()
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        logInfo(msg: "appActivated")
                        SGContext.shared.appEventDispatcher.notify(.appActivated)
                    } else if newPhase == .inactive {
                        logInfo(msg: "appDeactivated")
                        SGContext.shared.appEventDispatcher.notify(.appDeactivated)
                    } else if newPhase == .background {
                        logInfo(msg: "app is in background mode")
                        SGContext.shared.appEventDispatcher.notify(.appDeactivated)
                    }
                }
        }
    }
}

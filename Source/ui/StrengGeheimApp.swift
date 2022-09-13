//
//  StrengGeheimApp.swift
//  StrengGeheim
//
//  Created by Alexander Dittner on 12.09.2022.
//

import SwiftUI

@main
struct StrengGeheimApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environment(\.colorScheme, .dark)
        }
    }
}

struct ContentView: View {
    @ObservedObject var navigator = Navigator.shared
    @ObservedObject var alertBox = AlertBox.shared

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let pos = navigator.screenPosition.xPosition(id: .login) {
                    LoginView()
                        .background(AppBG())
                        .offset(x: pos * geo.size.width, y: 0)
                        .transition(.move(edge: navigator.screenPosition.goBack ? .leading : .trailing))
                }

                if let pos = navigator.screenPosition.xPosition(id: .index) {
                    IndexView()
                        .background(AppBG())
                        .offset(x: pos * geo.size.width, y: 0)
                        .transition(.move(edge: navigator.screenPosition.goBack ? .leading : .trailing))
                }
                
                if let pos = navigator.screenPosition.xPosition(id: .cardList) {
                    CardListView()
                        .background(AppBG())
                        .offset(x: pos * geo.size.width, y: 0)
                        .transition(.move(edge: navigator.screenPosition.goBack ? .leading : .trailing))
                }
            }
            .alert(item: $alertBox.message) { msg in
                Alert(
                    title: Text(msg.title),
                    message: Text(msg.details),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct AppBG: View {
    var body: some View {
        Color.SG.appBgColor.color.edgesIgnoringSafeArea(.bottom)
    }
}

import SwiftUI

struct ContentViewMacOS: View {
    @ObservedObject var navigator = Navigator.shared
    @ObservedObject var alertBox = AlertBox.shared
    
    func onTapped() {
        logInfo(msg: "Tapped!")
    }

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

                if let pos = navigator.screenPosition.xPosition(id: .cardEdit) {
                    CardEditView()
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
        }.colorScheme(.dark)
        .frame(minWidth: 500, idealWidth: 800, idealHeight: 1000, alignment: .topLeading)
        .onTapGesture(perform: self.onTapped)
    }
}

struct AppBG: View {
    var body: some View {
        Color.SG.appBg
    }
}

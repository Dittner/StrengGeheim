import Combine
import SwiftUI

struct LoginView: View {
    @ObservedObject var vm = LoginVM.shared

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Spacer()

                Text("SCHLÜSSEL")
                    .allowsTightening(false)
                    .font(Font.custom(.helveticaNeue, size: 12))
                    .lineLimit(1)
                    .foregroundColor(Color.SG.gray)
                    .frame(width: 300, alignment: .leading)
                    .offset(x: 10, y: 36)
                    .zIndex(1)

                #if os(iOS)

                    SecureField("", text: $vm.user.password) {
                        vm.login()
                    }
                    .font(Font.custom(.OpenSansSemibold, size: 20))
                    .frame(width: 280, height: 50, alignment: .leading)
                    .foregroundColor(Color.SG.tint)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
                    .background(Color.SG.black.cornerRadius(6))
                    .contentShape(Rectangle())

                #elseif os(OSX)

                    TextInput(title: "", text: $vm.user.password, textColor: NSColor.SG.tint, font: NSFont(name: .OpenSansSemibold, size: 25), alignment: .left, isFocused: true, isSecure: true, format: nil, isEditable: true, onEnterAction: { self.vm.login() })
                        .frame(width: 280, height: 50, alignment: .leading)
                        .colorScheme(.dark)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                        .background(Color.SG.black.cornerRadius(6))

                #endif

//                Button(action: vm.login) {
//                    Text("Anmelden")
//                        .font(Font.custom(.helveticaNeue, size: 18))
//                        .lineLimit(1)
//                        .frame(width: 300, height: 45)
//                        .foregroundColor(Color.SG.tint)
//                        //.background(Color.SG.tint.cornerRadius(6))
//                }.buttonStyle(PlainButtonStyle())

                Text(vm.errorMsg)
                    .foregroundColor(Color.SG.red)
                    .frame(height: 50)
                    .opacity(vm.errorMsg.count > 0 ? 1 : 0)

                ActivityIndicator(isAnimating: vm.isLoading)
                    .frame(width: 50, height: 50)

                Spacer()
            }.frame(maxWidth: .infinity)
        }
    }
}

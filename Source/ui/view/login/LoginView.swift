import Combine
import SwiftUI

struct LoginView: View {
    @ObservedObject var vm = LoginVM.shared

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Spacer()

                Text("S.....G.....")
                    .font(Font.custom(.helveticaNeue, size: 50))
                    .lineLimit(1)
                    .foregroundColor(Color.SG.tint.color)

                Text("Schlüssel")
                    .allowsTightening(false)
                    .font(Font.custom(.helveticaNeue, size: 11))
                    .lineLimit(1)
                    .foregroundColor(Color.SG.gray.color)
                    .frame(width: 300, alignment: .leading)
                    .offset(x: 10, y: 35)
                    .zIndex(1)

                SecureField("", text: $vm.user.password) {
                    vm.login()
                }
                .font(Font.custom(.helveticaNeue, size: 16))
                .frame(width: 280, height: 40, alignment: .leading)
                .foregroundColor(Color.SG.tint.color)
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .background(Color.black.cornerRadius(6))

                Button(action: vm.login) {
                    Text("Anmelden")
                        .font(Font.custom(.helveticaNeue, size: 16))
                        .lineLimit(1)
                        .frame(width: 300, height: 45)
                        .foregroundColor(Color.SG.black.color)
                        .background(Color.SG.tint.color.cornerRadius(6))
                }

                Spacer().frame(height: 20)

                Text(vm.errorMsg)
                    .foregroundColor(Color.SG.red.color)
                    .frame(height: 50)
                    .opacity(vm.errorMsg.count > 0 ? 1 : 0)

                ActivityIndicator(isAnimating: vm.isLoading)
                    .frame(width: 50, height: 50)

                Spacer()
            }.frame(maxWidth: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

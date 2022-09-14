import Combine
import SwiftUI

struct CardEditView: View {
    @ObservedObject var vm = CardEditVM.shared

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                NavigationBar { navigationBarSideWidth in
//                    TextButton(text: "Absagen", textColor: Color.SG.tint.color, font: Font.custom(.helveticaNeue, size: 18)) {
//                        vm.cancel()
//                    }
//                    .padding(.horizontal)
//                    .navigationBarLeading(navigationBarSideWidth)
                    
                    IconButton(name: .cancel, size: Constants.iconSize, iconColor: Color.SG.tint.color) {
                        self.vm.cancel()
                    }.navigationBarLeading(navigationBarSideWidth)

                    Text("Karte")
                        .font(Font.custom(.helveticaNeueBold, size: 18))
                        .foregroundColor(Color.SG.navbarTitle.color)
                        .navigationBarTitle(navigationBarSideWidth)
                    
                    IconButton(name: .apply, size: Constants.iconSize, iconColor: Color.SG.tint.color) {
                        self.vm.apply()
                    }.navigationBarTrailing(navigationBarSideWidth)
                }

                CardForm()

                Spacer()
            }
        }
    }
}

struct CardForm: View {
    @ObservedObject var vm = CardEditVM.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Titel")
                .allowsTightening(false)
                .font(Font.custom(.helveticaNeue, size: 11))
                .lineLimit(1)
                .foregroundColor(Color.SG.gray.color)
                .frame(width: 300, alignment: .leading)
                .offset(x: 10, y: 15)
                .zIndex(1)

            TextField("", text: $vm.title)
                .font(Font.custom(.helveticaNeue, size: 16))
                .frame(height: 40, alignment: .leading)
                .foregroundColor(Color.SG.text.color)
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .background(Color.black.cornerRadius(6))
            
            Text("Inhalt")
                .allowsTightening(false)
                .font(Font.custom(.helveticaNeue, size: 11))
                .lineLimit(1)
                .foregroundColor(Color.SG.gray.color)
                .frame(width: 300, alignment: .leading)
                .offset(x: 10, y: 15)
                .zIndex(1)
            
            TextEditor(text: $vm.text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(Font.custom(.helveticaNeue, size: 16))
                .foregroundColor(Color.SG.text.color)
                .padding(.horizontal, 5)
                .padding(.top, 12)
                .background(Color.black.cornerRadius(6))
            
            Spacer()

        }.frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

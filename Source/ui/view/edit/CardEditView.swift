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

                    IconButton(name: .prev, size: Constants.iconSize, iconColor: Color.SG.tint) {
                        self.vm.goBack()
                    }.navigationBarLeading(navigationBarSideWidth)

                    Text("Karte")
                        .font(Font.custom(.helveticaNeueBold, size: 18))
                        .foregroundColor(Color.SG.navbarTitle)
                        .navigationBarTitle(navigationBarSideWidth)

                    IconButton(name: .apply, size: Constants.iconSize, iconColor: Color.SG.tint) {
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
            Text("TITEL")
                .allowsTightening(false)
                .font(Font.custom(.helveticaNeue, size: 12))
                .lineLimit(1)
                .foregroundColor(Color.SG.gray)
                .offset(x: 10, y: 16)
                .zIndex(1)

            HStack(alignment: .center, spacing: 5) {
                #if os(iOS)

                    TextField("", text: $vm.title)
                        .font(Font.custom(.OpenSansSemibold, size: 21))
                        .frame(height: 40, alignment: .leading)
                        .foregroundColor(Color.SG.text)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .background(Color.black.cornerRadius(6))

                #elseif os(OSX)

                    TextInput(title: "", text: $vm.title, textColor: NSColor.SG.text, font: NSFont(name: .OpenSansSemibold, size: 21), alignment: .left, isFocused: false, isSecure: false, format: nil, isEditable: true, onEnterAction: {})
                        .frame(height: 40, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .saturation(0)
                        .background(Color.SG.black.cornerRadius(6))

                #endif

                CardPosition()

                BlackIconButton(name: .increase, size: Constants.iconSize, iconColor: Color.SG.text) {
                    self.vm.incCardPosition()
                }

                BlackIconButton(name: .decrease, size: Constants.iconSize, iconColor: Color.SG.text) {
                    self.vm.decCardPosition()
                }
            }

            Text("INHALT")
                .allowsTightening(false)
                .font(Font.custom(.helveticaNeue, size: 12))
                .lineLimit(1)
                .foregroundColor(Color.SG.gray)
                .offset(x: 10, y: 16)
                .zIndex(1)

            #if os(iOS)

                TextEditor(text: $vm.text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.custom(.OpenSansReg, size: 18))
                    .foregroundColor(Color.SG.text)
                    .padding(.horizontal, 5)
                    .padding(.top, 12)
                    .background(Color.black.cornerRadius(6))

            #elseif os(OSX)

                MacEditorTextView(text: $vm.text, isEditable: true, font: NSFont(name: .OpenSansReg, size: 18),
                                  onEditingChanged: {}, onCommit: {}, onTextChange: { _ in })
                    .padding(.leading, 5)
                    .padding(.trailing, -15)
                    .padding(.top, 20)
                    .background(Color.SG.black.cornerRadius(6))

            #endif

            Button(action: vm.removeCard) {
                Text("Löschen")
                    .font(Font.custom(.helveticaNeue, size: 18))
                    .lineLimit(1)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.SG.tint)
            }.buttonStyle(PlainButtonStyle())
                .popover(isPresented: self.$vm.showAlert, arrowEdge: .bottom) {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Soll die Karte gelöscht werden?")
                            .font(Font.custom(.helveticaNeue, size: 18))
                            .foregroundColor(Color.SG.navbarTitle)
                        
                        HStack(alignment: .center, spacing: 10) {
                            TextButton(text: "Nein", textColor: Color.SG.navbarTitle, font: Font.custom(.helveticaNeueBold, size: 18)) {
                                vm.cancelRemove()
                            }.frame(width: 100, alignment: .center)
                            TextButton(text: "Ja", textColor: Color.SG.tint, font: Font.custom(.helveticaNeueBold, size: 18)) {
                                vm.removeCard()
                            }.frame(width: 100, alignment: .center)
                        }
                    }.padding()
                }

            Spacer()

        }.frame(maxWidth: .infinity)
            .padding(.horizontal)
    }
}

struct CardPosition: View {
    @ObservedObject var vm = CardEditVM.shared

    var body: some View {
        ZStack {
            Text("POS.")
                .allowsTightening(false)
                .font(Font.custom(.helveticaNeue, size: 12))
                .lineLimit(1)
                .foregroundColor(Color.SG.gray)
                .offset(x: 0, y: -15)
                .zIndex(1)

            Text("\(vm.cardPos)")
                .allowsTightening(false)
                .font(Font.custom(.OpenSansSemibold, size: 21))
                .lineLimit(1)
                .foregroundColor(Color.SG.text)
                .frame(width: 50, height: 50, alignment: .center)
                .offset(x: 0, y: 5)
                .background(Color.SG.black.cornerRadius(6))
        }
    }
}

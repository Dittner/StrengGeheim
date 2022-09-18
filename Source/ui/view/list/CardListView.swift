import Combine
import SwiftUI

struct CardListView: View {
    @ObservedObject var vm = CardListVM.shared

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                NavigationBar { navigationBarSideWidth in
                    IconButton(name: .prev, size: Constants.iconSize, iconColor: Color.SG.tint) {
                        self.vm.goBack()
                    }.navigationBarLeading(navigationBarSideWidth)

                    Text(vm.title)
                        .font(Font.custom(.helveticaNeueBold, size: 18))
                        .foregroundColor(Color.SG.navbarTitle)
                        .navigationBarTitle(navigationBarSideWidth)

                    IconButton(name: .plus, size: Constants.iconSize, iconColor: Color.SG.tint) {
                        self.vm.createCard()
                    }.navigationBarTrailing(navigationBarSideWidth)
                }

                if vm.isLoading {
                    Spacer()
                    ActivityIndicator(isAnimating: vm.isLoading)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("SUCHEN")
                                .allowsTightening(false)
                                .font(Font.custom(.helveticaNeue, size: 12))
                                .lineLimit(1)
                                .foregroundColor(Color.SG.gray)
                                .offset(x: 10, y: 16)
                                .zIndex(1)

                            HStack(alignment: .center, spacing: 5) {
                                #if os(iOS)

                                    TextField("", text: $vm.user.filter)
                                        .font(Font.custom(.OpenSansSemibold, size: 21))
                                        .frame(height: 40, alignment: .leading)
                                        .foregroundColor(Color.SG.text)
                                        .padding(.horizontal, 10)
                                        .padding(.top, 10)
                                        .background(Color.SG.black.cornerRadius(6))

                                #elseif os(OSX)

                                    TextInput(title: "", text: $vm.user.filter, textColor: NSColor.SG.text, font: NSFont(name: .OpenSansSemibold, size: 21), alignment: .left, isFocused: false, isSecure: false, format: nil, isEditable: true, onEnterAction: {})
                                        .frame(height: 40, alignment: .leading)
                                        .padding(.horizontal, 10)
                                        .padding(.top, 10)
                                        .saturation(0)
                                        .background(Color.SG.black.cornerRadius(6))

                                #endif
                            }

                            ForEach(vm.cards, id: \.self.uid) { card in
                                CardCell(card) {
                                    self.vm.editCard(card)
                                }
                            }
                        }.padding(.horizontal, 20)

                        Spacer().frame(height: 20)
                    }
                    .clipped()
                }
            }
        }
    }
}

struct CardCell: View {
    let title: String
    let text: String
    let editAction: () -> Void

    init(_ card: Card, editAction: @escaping () -> Void) {
        title = card.title
        text = card.text
        self.editAction = editAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(Font.custom(.OpenSansSemibold, size: 21))
                .foregroundColor(Color.SG.text)

            Text(text)
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.custom(.OpenSansReg, size: 18))
                .foregroundColor(Color.SG.text)
                .padding(.bottom, 25)

            HSeparatorView(horizontalPadding: 0)
                .padding(.leading, -20)
                .padding(.trailing, -50)
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.SG.transparent)
        .onTapGesture(count: 2, perform: {
            self.editAction()
        })
    }
}

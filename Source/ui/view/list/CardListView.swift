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
                        Spacer().frame(height: 20)
                        VStack(spacing: 20) {
                            ForEach(vm.cards, id: \.self.uid) { card in
                                CardCell(card) {
                                    self.vm.editCard(card)
                                }
                            }
                        }
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
        HStack(alignment: .center, spacing: 0) {
            Spacer().frame(width: 20)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(Font.custom(.OpenSansSemibold, size: 21))
                    .foregroundColor(Color.SG.text)

                Text(text)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.custom(.OpenSansLight, size: 21))
                    .foregroundColor(Color.SG.text)
                    .padding(.bottom, 25)

                HSeparatorView(horizontalPadding: 0)
                    .padding(.leading, -20)
                    .padding(.trailing, -50)
            }

            IconButton(name: .next, size: Constants.iconSize, iconColor: Color.SG.dark) {
                self.editAction()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

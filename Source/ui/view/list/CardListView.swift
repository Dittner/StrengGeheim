import Combine
import SwiftUI

struct CardListView: View {
    @ObservedObject var vm = CardListVM.shared

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                NavigationBar { navigationBarSideWidth in
                    IconButton(name: .prev, size: Constants.iconSize, iconColor: Color.SG.tint.color) {
                        self.vm.goBack()
                    }.navigationBarLeading(navigationBarSideWidth)

                    Text(vm.title)
                        .font(Font.custom(.helveticaNeue, size: 18))
                        .foregroundColor(Color.SG.tint.color)
                        .navigationBarTitle(navigationBarSideWidth)
                    
                    IconButton(name: .plus, size: Constants.iconSize, iconColor: Color.SG.tint.color) {
                        self.vm.createCard()
                    }.navigationBarTrailing(navigationBarSideWidth)
                }

                if vm.isLoading {
                    Spacer()
                    ActivityIndicator(isAnimating: vm.isLoading)
                    Spacer()
                } else {
                    VStack(spacing: 0) {
                        ForEach(vm.cards, id: \.self.uid) { card in
                            CardCell(card) {
                                self.vm.editCard(card)
                            }
                        }
                        
                        Spacer()
                    }
                    .clipped()
                }
            }
        }
    }
}

struct CardCell: View {
    let text: String
    let editAction: () -> Void

    init(_ card: Card, editAction: @escaping () -> Void) {
        text = card.text
        self.editAction = editAction
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Spacer().frame(width: 20)

                Text(text)
                    .font(Font.custom(.helveticaNeue, size: 24))
                    .foregroundColor(Color.SG.white.color)
                    .lineLimit(1)
                    .frame(height: Constants.cellHeight)

                Spacer()
                
                IconButton(name: .next, size: Constants.iconSize, iconColor: Color.SG.white.color) {
                    self.editAction()
                }
            }

            HSeparatorView(horizontalPadding: 0)
        }.frame(height: Constants.cellHeight)
    }
}

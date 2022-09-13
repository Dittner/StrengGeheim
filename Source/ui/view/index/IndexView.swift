import Combine
import SwiftUI

struct IndexView: View {
    @ObservedObject var vm = IndexVM.shared

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                NavigationBar { navigationBarSideWidth in
                    IconButton(name: .prev, size: Constants.iconSize, iconColor: Color.SG.tint.color) {
                        self.vm.goBack()
                    }.navigationBarLeading(navigationBarSideWidth)

                    Text("INDEX")
                        .font(Font.custom(.helveticaNeue, size: 18))
                        .foregroundColor(Color.SG.tint.color)
                        .navigationBarTitle(navigationBarSideWidth)

                }

                ForEach(vm.indexIDs, id: \.self) { id in
                    IndexIDCell(id: id) {
                        self.vm.openIndex(id)
                    }
                }
            }
        }
    }
}

struct IndexIDCell: View {
    let title: String
    let selectAction: () -> Void

    init(id: CardIndexID, selectAction: @escaping () -> Void) {
        title = id.getTitle()
        self.selectAction = selectAction
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Spacer().frame(width: 50)
                
                Spacer()

                Text(title)
                    .font(Font.custom(.helveticaLight, size: 24))
                    .foregroundColor(Color.SG.white.color)
                    .lineLimit(1)
                    .frame(height: Constants.cellHeight)

                Spacer()

                IconButton(name: .next, size: Constants.iconSize, iconColor: Color.SG.white.color) {
                    self.selectAction()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            HSeparatorView(horizontalPadding: 0)
        }
    }
}

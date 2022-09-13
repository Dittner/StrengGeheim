import Combine
import SwiftUI

struct HSeparatorView: View {
    let horizontalPadding: CGFloat

    init(horizontalPadding: CGFloat = 0) {
        self.horizontalPadding = horizontalPadding
    }

    var body: some View {
        Color.SG.white.color.opacity(0.15)
            .padding(.horizontal, horizontalPadding)
            .frame(height: 0.5)
            .frame(maxWidth: .infinity)
    }
}

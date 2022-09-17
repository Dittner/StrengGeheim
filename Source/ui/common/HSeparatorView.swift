import Combine
import SwiftUI

#if os(iOS)

    struct HSeparatorView: View {
        let horizontalPadding: CGFloat

        init(horizontalPadding: CGFloat = 0) {
            self.horizontalPadding = horizontalPadding
        }

        var body: some View {
            Color.SG.text.opacity(0.2)
                .padding(.horizontal, horizontalPadding)
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
        }
    }

#elseif os(OSX)
    struct HSeparatorView: View {
        let horizontalPadding: CGFloat

        init(horizontalPadding: CGFloat = 0) {
            self.horizontalPadding = horizontalPadding
        }

        var body: some View {
            Color.SG.text.opacity(0.2)
                .padding(.horizontal, horizontalPadding)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
    }

#endif

import SwiftUI

struct DexButton: View {
  var title: String
  var fontSize: CGFloat = 24
  var action: () -> Void

  var body: some View {
    Button {
      action()
    } label: {
      ZStack {
        Image(.buttonBg)
          .resizable()
          .scaledToFit()

        Text(title)
          .dotFont(size: fontSize)
          .padding(.bottom, 4)
      }
    }
  }
}

struct DexLink: View {
  var title: String
  var url: URL
  var fontSize: CGFloat = 24

  var body: some View {
    Link(destination: url, label: {
      ZStack {
        Image(.buttonBg)
          .resizable()
          .scaledToFit()

        Text(title)
          .dotFont(size: fontSize)
          .padding(.bottom, 4)
      }
    })
  }
}

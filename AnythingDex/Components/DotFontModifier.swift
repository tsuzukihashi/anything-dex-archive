import SwiftUI

struct DotFontModifier: ViewModifier {
  let size: CGFloat

  func body(content: Content) -> some View {
    content.font(.dot(size: size))
  }
}

extension View {
  func dotFont(size: CGFloat) -> some View {
    self.modifier(DotFontModifier(size: size))
  }
}

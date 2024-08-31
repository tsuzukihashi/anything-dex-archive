import SwiftUI

extension String {
  static var dotFontName: String = "DotGothic16-Regular"
}

extension Font {
  static func dot(size: CGFloat) -> Font {
    Font.custom(.dotFontName, size: size)
  }
}

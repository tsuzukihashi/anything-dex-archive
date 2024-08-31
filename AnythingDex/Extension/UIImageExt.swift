import UIKit

extension UIImage {
  func compressImage() -> Data? {
    let resizedImage = self.aspectFittedToHeight(800)
    return resizedImage.jpegData(compressionQuality: 0.2)
  }

  func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
    let scale = newHeight / self.size.height
    let newWidth = self.size.width * scale
    let newSize = CGSize(width: newWidth, height: newHeight)
    let renderer = UIGraphicsImageRenderer(size: newSize)

    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }

  // percentage:圧縮率
  func resizeImage(withPercentage percentage: CGFloat) -> UIImage? {
    // 圧縮後のサイズ情報
    let canvas = CGSize(
      width: size.width * percentage,
      height: size.height * percentage
    )
    // 圧縮画像を返す
    return UIGraphicsImageRenderer(
      size: canvas,
      format: imageRendererFormat
    )
    .image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
}

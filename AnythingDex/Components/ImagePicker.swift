import SwiftUI
import UIKit

public struct ImagePickerSwiftUI: UIViewControllerRepresentable {
  @Environment(\.presentationMode) private var presentationMode
  @Binding var selectedImage: UIImage?

  public init(
    selectedImage: Binding<UIImage?>
  ) {
    self._selectedImage = selectedImage
  }

  public func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .camera
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  final public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePickerSwiftUI

    init(_ parent: ImagePickerSwiftUI) {
      self.parent = parent
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        parent.selectedImage = image
      }

      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}

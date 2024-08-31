import SwiftUI

struct ItemCell: View {
  var item: Item
  
  var body: some View {
    HStack {
      Text("No: \(item.id)")
        .dotFont(size: 14)
      Text(item.name)
        .dotFont(size: 18)
      Spacer()
      Image(uiImage: UIImage(data: item.imageData) ?? .album)
        .resizable()
        .scaledToFill()
        .frame(width: 44, height: 44)
        .cornerRadius(8)
        .clipped()

    }
  }
}

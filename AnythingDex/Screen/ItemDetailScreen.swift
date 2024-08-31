import SwiftUI
import AVFAudio
import AVFoundation

struct ItemDetailScreen: View {
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) var dismiss
  @State var showDeleteDialog: Bool = false

    private let synthesizer = AVSpeechSynthesizer()

  var item: Item
    var body: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 8) {
          Image(uiImage: UIImage(data: item.imageData) ?? .album)
            .resizable()
            .scaledToFill()
            .frame(maxHeight: 400)
            .cornerRadius(16)
            .clipped()

          Text(item.name)
            .dotFont(size: 20)

          Text(item.desc)
            .dotFont(size: 16)

          Text("Genre: \(item.genre)")
            .dotFont(size: 14)

          Text("Created: \(item.createdAt.formatted())")
            .dotFont(size: 14)

          HStack {
            Button {
              speech()
            } label: {
              VStack(spacing: -4) {
                Image(.voice)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 64, height: 64)
                  .clipShape(Circle())

                Text("Voice")
                  .dotFont(size: 10)
              }
            }
            let shareItem = ShareItem(
              image: Image(uiImage: UIImage(data: item.imageData) ?? .album),
              description: "No.\(item.id) \(item.name)\n \(item.desc) \n\(item.genre) \n#AnythingDex #なんでも図鑑"
            )

            ShareLink(
              item: shareItem,
              subject: Text(item.name),
              message: Text(shareItem.description),
              preview: SharePreview("\(item.name)", image: shareItem.image)) {
                VStack {
                  Image(.megaphone)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                  Text("Share")
                    .dotFont(size: 10)
                }
              }
          }
          .tint(.primary)
          .frame(maxWidth: .infinity)

        }
        .padding(.horizontal, 32)
      }
      .navigationTitle("No.\(item.id) \(item.name)")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            showDeleteDialog.toggle()
          }, label: {
            Image(.gomibako)
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)
          })
        }
      }
      .alert("Are you sure you want to delete it?", isPresented: $showDeleteDialog) {
        Button("Cancel", role: .cancel) {}
        Button("Delete", role: .destructive) {
          context.delete(item)
          try? context.save()
          dismiss()
        }
      }
    }

  func speech() {
    if synthesizer.isSpeaking {
      synthesizer.stopSpeaking(at: .immediate)

    } else {
      let local = Locale.preferredLanguages.first ?? "ja-JP"
      let genre = local == "ja-JP" ? "ジャンル" : "genre"
      let dot = local == "ja-JP" ? "。" : "."
      let text = AVSpeechUtterance(
        string: item.name + dot + item.desc + dot + genre + item.genre
      )
      let language = AVSpeechSynthesisVoice(language: local)
      text.voice = language
      synthesizer.speak(text)
    }
  }
}

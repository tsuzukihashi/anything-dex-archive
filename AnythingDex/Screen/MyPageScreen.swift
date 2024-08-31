import SwiftUI
import SwiftData

struct MyPageScreen: View {
  @AppStorage("totalItemCount") var totalItemCount: Int = 0
  @AppStorage("loginDate") var loginDate: Double = Date().timeIntervalSince1970
  @AppStorage("updatedDate") var updatedDate: Double = Date().timeIntervalSince1970
  @State var showDeleteDialog: Bool = false
  @State var showRealDeleteDialog: Bool = false

  @Environment(\.modelContext) private var modelContext

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          Image(.trainer)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)

          VStack(alignment: .leading) {
            Text("You")
              .dotFont(size: 14)
            Text("Number of finds")
              .dotFont(size: 14)

            HStack {
              Spacer()
              Text("\(totalItemCount) Count")
                .dotFont(size: 14)
            }

            Text("Date of first use")
              .dotFont(size: 14)
            HStack {
              Spacer()
              Text("\(Date(timeIntervalSince1970: loginDate).formatted())")
                .dotFont(size: 14)
            }

            Text("Date last used")
              .dotFont(size: 14)
            HStack {
              Spacer()
              Text("\(Date(timeIntervalSince1970: updatedDate).formatted())")
                .dotFont(size: 14)
            }
          }
          .multilineTextAlignment(.trailing)
        }

        VStack {
          Text("App")
            .dotFont(size: 28)

          HStack {
            DexButton(title: NSLocalizedString("Delete Data", comment: "")) {
              showDeleteDialog.toggle()
            }
            DexButton(title: NSLocalizedString("Premium", comment: "")) {

            }
            .disabled(true)
            .overlay {
              Text("Coming Soon!")
                .dotFont(size: 18)
                .foregroundStyle(.white)
            }
          }

          Text("External Links")
            .dotFont(size: 28)

          HStack {
            DexLink(title: NSLocalizedString("Recommend", comment: ""), url: URL(string: "https://apps.apple.com/jp/developer/ryo-tsudukihashi/id1320583602?l=true&see-all=i-phonei-pad-apps")!)
            DexLink(title: NSLocalizedString("Developer", comment: ""), url: URL(string: "https://twitter.com/tsuzuki817")!)
          }

          HStack {
            DexLink(title: NSLocalizedString("Terms of Use", comment: ""), url: URL(string: "https://panoramic-clematis-d8b.notion.site/9c9f8f0854c44f42b0894065c21e3d37")!)
            DexLink(title: NSLocalizedString("Disclaimer", comment: ""), url: URL(string: "https://panoramic-clematis-d8b.notion.site/a1485670e4aa4761b9a7e8c08df39844")!)
          }
        }
        .tint(.black)
        .frame(maxWidth: .infinity)

      }
      .padding(16)
    }
    .alert("Are you sure you want to delete all data?", isPresented: $showDeleteDialog, actions: {
      Button("Cancel", role: .cancel) {}
      Button(role: .destructive) {
        showRealDeleteDialog.toggle()
      } label: {
        Text("Yes")
      }
    })   
    .alert("Once deleted, data cannot be recovered. Are you sure?", isPresented: $showRealDeleteDialog, actions: {
      Button("Cancel", role: .cancel) {}
      Button(role: .destructive) {
        try? modelContext.delete(model: Item.self)
        totalItemCount = 0
      } label: {
        Text("All Delete")
      }
    })
  }
}

#Preview {
  MyPageScreen()
}

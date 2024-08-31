import SwiftUI
import SwiftData

struct LibraryScreen: View {
  @Environment(\.modelContext) private var context
  @EnvironmentObject var appEnvironment: AppEnvironment
  @Query private var items: [Item]

  var body: some View {
    NavigationStack {
      List {
        ForEach(items) { item in
          NavigationLink {
            ItemDetailScreen(item: item)
          } label: {
            ItemCell(item: item)
          }
        }
      }
      .overlay {
        if items.isEmpty {
          ContentUnavailableView {
            VStack {
              Image(.gameboyAngle)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
              Text("Take a picture and register!")
                .dotFont(size: 24)
            }
          } description: {
            Text("The registered photos will be displayed in the picture book!")
              .dotFont(size: 14)
          } actions: {
            Image(.yajirushiBottom)
              .resizable()
              .scaledToFit()
              .frame(width: 32, height: 32)
          }
        }
      }
      .navigationTitle("Library")
    }
  }
}

#Preview {
  LibraryScreen()
}

import GoogleGenerativeAI
import SwiftUI

struct ErrorView: View {
  var error: Error
  @State private var isDetailsSheetPresented = false
  var body: some View {
    HStack {
      Text("An error occurred.")
      Button(action: { isDetailsSheetPresented.toggle() }) {
        Image(systemName: "info.circle")
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
    .listRowSeparator(.hidden)
    .sheet(isPresented: $isDetailsSheetPresented) {
      ErrorDetailsView(error: error)
    }
  }
}

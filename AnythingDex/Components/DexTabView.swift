import SwiftUI

struct DexTabView: View {
  @EnvironmentObject var appEnvironment: AppEnvironment
  @Binding var selectedTab: RootTabType
  @State var yOffset: CGFloat = 0

  var body: some View {
    GeometryReader { proxy in
      HStack(spacing: 0) {
        ForEach(RootTabType.allCases) { tab in
          Button {
            withAnimation(.easeInOut(duration: 0.2)) {
              selectedTab = tab
              yOffset = -80
            }
            withAnimation(.easeInOut(duration: 0.1).delay(0.05)) {
              yOffset = 0
            }
          } label: {
            VStack {
              Image(tab.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .frame(maxWidth: .infinity)
                .foregroundColor(tab == selectedTab ? .red : .secondary)
                .scaleEffect(selectedTab == tab && yOffset != 0 ? 1.5 : 1)
              Text(tab.name)
                .font(.dot(size: 12))
                .foregroundColor(tab == selectedTab ? .red : .secondary)
            }
          }
        }
      }
      .overlay(alignment: .bottom) {
        Button {
          appEnvironment.showDiscoverView = true
        } label: {
          VStack(spacing: 0) {
            Image(.gameboyAngle)
              .resizable()
              .scaledToFit()
              .frame(width: 52, height: 52)
              .rotationEffect(.degrees(appEnvironment.currentTab == .index ? 0 : 360))
            Text("GET")
              .dotFont(size: 10)
          }
        }
        .tint(.primary)
      }
      .frame(maxWidth: .infinity)
      .background(alignment: .center) {
        Image(.finger)
          .resizable()
          .frame(width: 24, height: 24)
          .offset(x: -proxy.size.width / 5 + 8)
          .offset(x: indicatorOffset(width: proxy.size.width), y: yOffset)
      }
    }
    .frame(height: 30)
    .padding(.bottom, 10)
    .padding([.horizontal, .top])
  }

  func indicatorOffset(width: CGFloat) -> CGFloat {
    let index: CGFloat = CGFloat(selectedTab.index)
    if index == 0 { return 0 }
    let buttonWidth = width / CGFloat(RootTabType.allCases.count)

    return index * buttonWidth
  }
}

#Preview {
  DexTabView(selectedTab: .constant(.mypage))
}

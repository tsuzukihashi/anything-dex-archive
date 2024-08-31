import AVFAudio
import MarkdownUI
import PhotosUI
import SwiftUI
import SwiftData

struct CaptureScreen: View {
  let synthesizer = AVSpeechSynthesizer()

  @Environment(\.modelContext) private var context
  @AppStorage("totalItemCount") var totalItemCount: Int = 0
  @AppStorage("updatedDate") var updatedDate: Double = Date().timeIntervalSince1970

  @State var viewModel = CaptureViewModel()
  @State var showAlbum = false
  @State var showCamera = false
  @State var sourceType: SourceType = .camera

  @Environment(\.dismiss) var dismiss

  var body: some View {
      VStack {
          Text("AnythingDex")
            .dotFont(size: 32)

        if let image =  viewModel.selectedImage {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
            .cornerRadius(8)
        } else {
          Text(
            """
            Select an image from your camera or album!

            Tap the rocket after selecting an image, and Gemini, Google's AI, will read the image and explain it to you!

            Gemini will judge only by the image, so be careful not to make a mistake sometimes!
            """
          )
          .dotFont(size: 18)
          .padding(16)

        }

        if let apiResponse = viewModel.apiResponse {
          HStack {
            Image(.gameboyAngle)
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)

            VStack(alignment: .leading, content: {
              Text(apiResponse.name)
                .dotFont(size: 18)
              Text(apiResponse.description)
                .dotFont(size: 16)
              Text(apiResponse.genre)
                .dotFont(size: 12)
            })
          }

          Button(action: {
            add()
          }, label: {
            Text("Register")
              .dotFont(size: 20)
          })
          .buttonStyle(.borderedProminent)
        } else {
          if viewModel.inProgress {
            BannerView(type: .main)
              .frame(maxWidth: .infinity)
              .frame(maxHeight: .infinity)
          }
        }

        if let error = viewModel.error {
          ErrorView(error: error)
            .tag("errorView")
        }

        if viewModel.inProgress {
          VStack {
            LottieView(type: LottieAnimationType.random())
              .frame(width: 80, height: 80)
            Text("Analyzing images")
              .dotFont(size: 18)
          }
        } else {

          HStack {
            Button(action: {
              showCamera.toggle()
              sourceType = .camera
            }) {
              VStack(spacing: 0, content: {
                Image(.camera)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 80, height: 80)
                Text("Camera")
                  .dotFont(size: 14)
              })
              .padding(8)
            }

            Button(action: {
              showAlbum.toggle()
              sourceType = .album
            }) {
              VStack(spacing: 0, content: {
                Image(.album)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 80, height: 80)
                Text("Album")
                  .dotFont(size: 14)
              })
              .padding(8)
            }
          }
          .frame(maxWidth: .infinity)
          .foregroundStyle(.primary)
          .overlay(alignment: .center) {
            actionButtons
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background() {
        bg
      }
      .photosPicker(isPresented: $showAlbum, selection: $viewModel.selectedItem)
      .sheet(isPresented: $showCamera, onDismiss: {
        viewModel.onChangeImage(image: viewModel.selectedImage)
      }, content: {
        ImagePickerSwiftUI(selectedImage: $viewModel.selectedImage)
      })
      .onChange(of: viewModel.selectedItem, { oldValue, newValue in
        Task {
          await viewModel.onChangeItem(item: newValue)
        }
      })
      .overlay(alignment: .topTrailing) {
        closeButton
      }
  }


  var actionButtons: some View {
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
      .tint(.primary)
      .opacity(viewModel.apiResponse == nil ? 0 : 1)

      Spacer()

      Button(action: {
        Task {
          await viewModel.reason()
        }
      }, label: {
        VStack {
          Image(.rocket)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
          Text("RUN")
            .dotFont(size: 14)
        }
      })
      .tint(.primary)
      .opacity(viewModel.hiddenSubmitButton ? 0 : 1)
    }
    .padding(.horizontal)

  }

  var bg: some View {
    Image(.background)
      .resizable()
      .scaledToFill()
      .opacity(0.2)
  }

  var closeButton: some View {
    Button {
      dismiss()
    } label: {
      Image(.xmark)
        .resizable()
        .scaledToFit()
        .frame(width: 32, height: 32)
    }
    .padding(16)
  }

  @MainActor
  private func add() {
    guard let item = viewModel.genereteItem(
      sourceType: sourceType,
      totalCount: totalItemCount
    ) else { return }
    context.insert(item)
    update()
  }

  @MainActor
  private func update() {
    totalItemCount += 1
    updatedDate = Date().timeIntervalSince1970
    viewModel.clear()
    dismiss()
  }

  func speech() {
    guard let apiResponse = viewModel.apiResponse else { return }
    if synthesizer.isSpeaking {
      synthesizer.stopSpeaking(at: .immediate)

    } else {
      let text = AVSpeechUtterance(
        string: apiResponse.name + "." + apiResponse.description + "." + "ジャンル: " + apiResponse.genre
      )
      let language = AVSpeechSynthesisVoice(language: "ja-JP")
      text.voice = language
      synthesizer.speak(text)
    }
  }
}

#Preview {
  NavigationStack {
    CaptureScreen()
  }
}

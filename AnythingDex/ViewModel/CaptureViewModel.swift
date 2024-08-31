import GoogleGenerativeAI
import PhotosUI
import SwiftUI

@Observable
class CaptureViewModel {
  var selectedItem: PhotosPickerItem?
  var selectedImage: UIImage?

  var apiResponse: APIResponse?
  var outputText: String? = nil
  var inProgress = false
  var error: Error?
  var hiddenSubmitButton: Bool {
    selectedImage == nil
    || inProgress
    || apiResponse != nil
    || error != nil
  }

  private var model: GenerativeModel

  func clear() {
    selectedItem = nil
    selectedImage = nil
    apiResponse = nil
    outputText = nil
    error = nil
  }

  init() {
    model = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
  }

  func reason() async {
    defer {
      Task { @MainActor in
        inProgress = false
      }
    }

    do {
      inProgress = true
      error = nil
      outputText = ""
      apiResponse = nil
      let local = Locale.preferredLanguages.first ?? "ja-JP"

      let prompt = local == "ja-JP" ? """
      次の画像の名前と説明とジャンルのJSONオブジェクトを返します。
      説明はわかりやすく、ほどほどに詳しく、200文字程度にすること
      例)
      {
        "name": 名前,
        "descriptioin": 説明,
        "genre": ジャンル
      }
      """ : """
      Returns a JSON object with the name, description and genre of the following image.
      The description should be clear, moderately detailed, and about 200 characters.
      example)
      {
        "name": Name,
        "descriptioin": Description,
        "genre": Genre
      }
      """

      var images = [PartsRepresentable]()

      if let data = selectedImage?.compressImage() {
        images.append(ModelContent.Part.jpeg(data))
      }

      // stream response
      let outputContentStream = model.generateContentStream(prompt, images)

      for try await outputContent in outputContentStream {
        guard let line = outputContent.text else {
          return
        }

        outputText = (outputText ?? "") + line
      }

      let removeWN = outputText?.trimmingCharacters(in: .whitespacesAndNewlines)
      let replaceJson = removeWN?.replacingOccurrences(of: "json", with: "")
      let trimmedText = replaceJson?.replacingOccurrences(of: "```", with: "")


      guard
        let json = trimmedText,
        let data = json.data(using: .utf8)
      else { return }
      print(json)
      apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)

    } catch {
      self.error = error
    }
  }

  func onChangeItem(item: PhotosPickerItem?) async {
    clear()
    if let data = try? await item?.loadTransferable(type: Data.self) {
      if let uiImage = UIImage(data: data) {
        selectedImage = uiImage
      }
    }
  }

  func onChangeImage(image: UIImage?) {
    clear()
    selectedImage = image
  }

  func genereteItem(sourceType: SourceType, totalCount: Int) -> Item? {
    guard
      let apiResponse,
      let data = selectedImage?.compressImage()
    else { return nil }

    let item = Item(
      id: totalCount + 1,
      name: apiResponse.name,
      desc: apiResponse.description,
      imageData: data, 
      genre: apiResponse.genre,
      from: sourceType.rawValue,
      favorited: false,
      gps: nil,
      createdAt: .init(),
      updatedAt: .init()
    )

    return item
  }
}

import GoogleGenerativeAI
import MarkdownUI
import SwiftUI

extension SafetySetting.HarmCategory: CustomStringConvertible {
  public var description: String {
    switch self {
    case .dangerousContent: "Dangerous content"
    case .harassment: "Harassment"
    case .hateSpeech: "Hate speech"
    case .sexuallyExplicit: "Sexually explicit"
    case .unknown: "Unknown"
    case .unspecified: "Unspecified"
    }
  }
}

extension SafetyRating.HarmProbability: CustomStringConvertible {
  public var description: String {
    switch self {
    case .high: "High"
    case .low: "Low"
    case .medium: "Medium"
    case .negligible: "Negligible"
    case .unknown: "Unknown"
    case .unspecified: "Unspecified"
    }
  }
}

private struct SubtitleFormRow: View {
  var title: String
  var value: String

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.subheadline)
      Text(value)
    }
  }
}

private struct SubtitleMarkdownFormRow: View {
  var title: String
  var value: String

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.subheadline)
      Markdown(value)
    }
  }
}

private struct SafetyRatingsSection: View {
  var ratings: [SafetyRating]

  var body: some View {
    Section("Safety ratings") {
      List(ratings, id: \.self) { rating in
        HStack {
          Text("\(String(describing: rating.category))")
            .font(.subheadline)
          Spacer()
          Text("\(String(describing: rating.probability))")
        }
      }
    }
  }
}

struct ErrorDetailsView: View {
  var error: Error

  var body: some View {
    NavigationView {
      Form {
        switch error {
        case let GenerateContentError.internalError(underlying: underlyingError):
          Section("Error Type") {
            Text("Internal error")
          }

          Section("Details") {
            SubtitleFormRow(title: "Error description",
                            value: underlyingError.localizedDescription)
          }

        case let GenerateContentError.promptBlocked(response: generateContentResponse):
          Section("Error Type") {
            Text("Your prompt was blocked")
          }

          Section("Details") {
            if let reason = generateContentResponse.promptFeedback?.blockReason {
              SubtitleFormRow(title: "Reason for blocking", value: reason.rawValue)
            }

            if let text = generateContentResponse.text {
              SubtitleMarkdownFormRow(title: "Last chunk for the response", value: text)
            }
          }

          if let ratings = generateContentResponse.candidates.first?.safetyRatings {
            SafetyRatingsSection(ratings: ratings)
          }

        case let GenerateContentError.responseStoppedEarly(
          reason: finishReason,
          response: generateContentResponse
        ):

          Section("Error Type") {
            Text("Response stopped early")
          }

          Section("Details") {
            SubtitleFormRow(title: "Reason for finishing early", value: finishReason.rawValue)

            if let text = generateContentResponse.text {
              SubtitleMarkdownFormRow(title: "Last chunk for the response", value: text)
            }
          }

          if let ratings = generateContentResponse.candidates.first?.safetyRatings {
            SafetyRatingsSection(ratings: ratings)
          }

        default:
          Section("Error Type") {
            Text("Some other error")
          }

          Section("Details") {
            SubtitleFormRow(title: "Error description", value: error.localizedDescription)
          }
        }
      }
      .navigationTitle("Error details")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

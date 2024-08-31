import Foundation

/**
 一度Gemini APIを叩いて返却されたJSONをこの型に変換する
 */
struct APIResponse: Codable {
  var name: String
  var description: String
  var genre: String
}

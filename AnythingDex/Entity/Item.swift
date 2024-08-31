import Foundation
import SwiftData

@Model
final class Item {
  var id: Int
  var name: String
  var desc: String
  var imageData: Data
  var genre: String
  var from: String
  var favorited: Bool
  var gps: String?
  var createdAt: Date
  var updatedAt: Date

  init(
    id: Int,
    name: String,
    desc: String,
    imageData: Data,
    genre: String,
    from: String,
    favorited: Bool,
    gps: String? = nil,
    createdAt: Date,
    updatedAt: Date
  ) {
    self.id = id
    self.name = name
    self.desc = desc
    self.imageData = imageData
    self.genre = genre
    self.from = from
    self.favorited = favorited
    self.gps = gps
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

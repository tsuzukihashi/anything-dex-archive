import SwiftUI

struct ShareItem: Transferable {
  static var transferRepresentation: some TransferRepresentation {
    ProxyRepresentation(exporting: \.image)
  }
  public var image: Image
  public var description: String
}

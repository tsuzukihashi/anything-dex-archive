import SwiftUI
import NeumorphismUI

struct NeumophismEnvironment: EnvironmentKey {
  static var defaultValue: NeumorphismManager = NeumorphismManager(
    isDark: false,
    lightColor: Color(hex: "C1D2EB"),
    darkColor: Color(hex: "2C292C")
)
}

extension EnvironmentValues {
  public var neumophism: NeumorphismManager {
    get { self[NeumophismEnvironment.self] }
    set { self[NeumophismEnvironment.self] = newValue }
  }
}

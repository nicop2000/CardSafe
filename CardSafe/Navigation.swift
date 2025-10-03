import Foundation
import SwiftUI

final class NavigationModel: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
}

enum Route: Hashable {
    case card(Card, Bool)
}

import SwiftUI
import CryptoKit
import TipKit

@main
struct CardSafeApp: App {
    @State var isLocked = true
    @State var blurRadius : CGFloat = 0
    @StateObject private var navigationModel = NavigationModel()
    private let settingsAccessor = SettingsAccessor()

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavRoot(isLocked: $isLocked)
                    .environmentObject(navigationModel)
                    .environmentObject(settingsAccessor)
                    .privacy()
                    .locked(isLocked: $isLocked)
#if DEBUG
                    .task {
                        self.isLocked = false
                    }
#endif
            }
        }
    }
}

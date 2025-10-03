import SwiftUI

struct PrivacyModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        content
            .blur(radius: scenePhase != .active ? 10 : 0)
            .animation(.default, value: scenePhase)
    }
}

extension View {
    public func privacy() -> some View {
        modifier(PrivacyModifier())
    }
}

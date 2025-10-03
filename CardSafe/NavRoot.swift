import SwiftUI

struct NavRoot: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @Binding var isLocked: Bool

    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            ContentView(isLocked: $isLocked)
                .environmentObject(navigationModel)
                .navigationTitle("CardSafe")
                .navigationDestination(for: Route.self) { route in
                    switch route {
                        case .card(let card, let isNew):
                            CardEditView(card: card, isNew: isNew)
                                .environmentObject(navigationModel)
                    }
                }
        }
    }
}

import SwiftUI
import TipKit

struct ContentView: View {
    let accessor = KeychainAccessor()
    private let tip = AddTip()
    @State var cards: [Card] = []
    @EnvironmentObject var navigationModel: NavigationModel
    @State var toDelete: Card?
    @Binding var isLocked: Bool
    init(isLocked: Binding<Bool>) {
        self._isLocked = isLocked
        try? Tips.configure()
    }
    var body: some View {
        List {
            if cards.isEmpty {
                Section {
                    Text("No cards available. Tap the \(Image(systemName: "plus")) button to add a new card.")
                        .foregroundColor(.secondary)
                }
            }
            ForEach(cards) { card in
                NavigationLink(value: Route.card(card, false)) {
                    CardListItem(card: card)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                toDelete = card
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .alert("Sind Sie sicher, dass Sie diese Karte löschen möchten?", isPresented: Binding(get: { toDelete != nil }, set: { _ in  toDelete = nil })) {
            Button("Abbrechen", role: .cancel) { }
            Button(role: .destructive) {
                if let card = toDelete {
                    accessor.delete(cardId: card.id)
                    if let index = cards.firstIndex(of: card) {
                        cards.remove(at: index)
                    }
                }
            } label: {
                Text("Löschen")
            }
        }
        .background(.accent)
        .onAppear {
            cards = accessor.getAllCards()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                VStack {
                    Button {
                        tip.invalidate(reason: .actionPerformed)
                        let card = Card()
                        navigationModel.path.append(Route.card(card, true))
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popoverTip(tip, arrowEdge: .top)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation {
                        isLocked = true
                    }
                } label: {
                    Image(systemName: "lock.fill")
                }
            }
        }
    }
}

#Preview {
    ContentView(isLocked: .constant(false))
}

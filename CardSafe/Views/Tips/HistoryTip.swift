import TipKit

struct AddTip: Tip {
    var title: Text {
        Text("Neue Karten hinzufügen")
    }

    var message: Text? {
        Text("Deine Karten werden sicher gespeichert und sicher auf deine anderen Geräte über iCloud synchronisiert.")
    }
}

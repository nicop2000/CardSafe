import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var accessor: SettingsAccessor
    let keychainAccessor = KeychainAccessor()
    var body: some View {
        List {
            Section {
                Toggle("Synchronisierung für die ganze App", isOn: $accessor.globalSyncIndicator)
            } header: {
                Label("Synchronisation", systemImage: "network.badge.shield.half.filled")
            }
        }
    }
}

#Preview {
    SettingsView()
}

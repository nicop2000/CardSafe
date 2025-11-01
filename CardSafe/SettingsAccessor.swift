import Foundation

enum GlobalSettingsKeys: String {
    case globalSynchronize
}

enum LocalSettingsKeys: String {
    case updatedAllCardsSync
}
class SettingsAccessor: ObservableObject {
    @SyncableUserDefaultsValue(key: GlobalSettingsKeys.globalSynchronize.rawValue, defaultValue: false) var globalSyncIndicator: Bool
    @UserDefaultsValue(key: LocalSettingsKeys.updatedAllCardsSync.rawValue, defaultValue: false) var updatedAllCardsSync: Bool
}

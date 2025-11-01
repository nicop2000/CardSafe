import Foundation

@propertyWrapper public struct UserDefaultsValue<T: LosslessStringConvertible> {
    public var key: String
    public var defaultValue: T
    public var userDefaults: UserDefaults
    public var wrappedValue: T {
        get {
            guard let value = userDefaults.string(forKey: key) else {
                return defaultValue
            }
            return T(value) ?? defaultValue
        }
        set {
            userDefaults.setValue(newValue.description, forKey: key)
        }
    }

    public init(key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}
@propertyWrapper public struct SyncableUserDefaultsValue<T: LosslessStringConvertible> {
    public var key: String
    public var defaultValue: T
    public var store: NSUbiquitousKeyValueStore = .default
    public var wrappedValue: T {
        get {
            guard let value = store.string(forKey: key) else {
                return defaultValue
            }
            return T(value) ?? defaultValue
        }
        set {
            store.set(newValue.description, forKey: key)
        }
    }

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

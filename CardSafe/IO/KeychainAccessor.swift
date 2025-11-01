import KeychainManager
import CryptoKit
import Foundation

class KeychainAccessor {
    let keychainManager = KeychainManager(
        serviceName: "CardSafe",
        accessGroup: nil
    )
    let lockPassword = "lockPassword"

    private let cryptoService = CryptoService()

    func getAllCards() -> [Card] {
        let allKeys = keychainManager.genericItems.allKeys().filter { $0 != lockPassword }
        var cards: [Card] = []
        for key in allKeys {
            do {
                let cardData: Data = try keychainManager.genericItems.fetchItem(key: key)
                let decryptedData = try cryptoService.decryptBase64ToData(cardData)
                let card: Card = try JSONDecoder().decode(Card.self, from: decryptedData)
                cards.append(card)
            } catch let cryptoError as CryptoKitError {
                print("CryptoKit-Error: Retrieving card for key \(key): \(cryptoError)")
                print("Possibly wrong password or corrupted data. Will delete the corrupted entry.")
                delete(cardId: key)
            } catch {
                print("Error retrieving card for key \(key): \(error)")
            }
        }
        return cards.sorted()
    }

    func setSyncSyncForAll(sync: Bool) {
        let cards = getAllCards()
        cards.forEach {
            save(card: $0, sync: sync)
        }
    }

    func save(card: Card, sync: Bool) {
        do {
            let jsonCard = try JSONEncoder().encode(card)
            let encryptedCard = try cryptoService.encryptToBase64(plaintext: jsonCard)
            try keychainManager.genericItems.saveItem(item: encryptedCard, key: card.id, synchronize: sync, updateWhenExists: true)
        } catch {
            print("Error saving item to keychain: \(error)")
        }
    }

    func delete(card: Card) {
        do {
            try keychainManager.genericItems.deleteItem(key: card.id)
        } catch {
            print("Error deleting item from keychain: \(error)")
        }
    }

    func delete(cardId: String) {
        do {
            try keychainManager.genericItems.deleteItem(key: cardId)
        } catch {
            print("Error deleting item from keychain: \(error)")
        }
    }

    func saveLockPassword(_ password: String) {
        do {
            let hashedPassword = cryptoService.hashPassword(password)
            try keychainManager.genericItems.saveItem(item: hashedPassword, key: lockPassword, synchronize: true, updateWhenExists: true)
        } catch {
            print("Error saving lock password to keychain: \(error)")
        }
    }

    private func getLockPassword() -> String? {
        do {
            let savedPassword: String = try keychainManager.genericItems.fetchItem(key: lockPassword)
            return savedPassword
        } catch {
            print("Error retrieving lock password from keychain: \(error)")
            return nil
        }
    }

    func isLockPasswordSet() -> Bool {
        do {
            let storedPassword = getLockPassword()
            if let storedPassword {
                return storedPassword.isEmpty == false
            }
            return false
        } catch {
            print("Error retrieving lock password from keychain: \(error)")
            return false
        }
    }

    func checkIfLockPasswordCorrect(_ password: String) -> Bool {
        guard let storedPassword = getLockPassword() else { return false }
        return cryptoService.hashPassword(password) == storedPassword
    }
}

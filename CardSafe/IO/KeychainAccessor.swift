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

    func save(card: Card) {
        do {
            let jsonCard = try JSONEncoder().encode(card)
            let encryptedCard = try cryptoService.encryptToBase64(plaintext: jsonCard)
            try keychainManager.genericItems.saveItem(item: encryptedCard, key: card.id, synchronize: true, updateWhenExists: true)
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
            try keychainManager.genericItems.saveItem(item: password, key: lockPassword, synchronize: true, updateWhenExists: true)
        } catch {
            print("Error saving lock password to keychain: \(error)")
        }
    }

    func getLockPassword() -> String? {
        do {
            return try keychainManager.genericItems.fetchItem(key: "lockPassword")
        } catch {
            print("Error retrieving lock password from keychain: \(error)")
            return nil
        }
    }
}

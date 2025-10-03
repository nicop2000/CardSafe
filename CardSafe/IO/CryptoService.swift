import Foundation
import CryptoKit

/// Symmetric encryption service using AES-GCM (CryptoKit).
/// - Encrypts/decrypts Data or String and returns Base64 encoded strings for ciphertext.
/// - WARNING: embedding the key in code is insecure. See alternatives below.
public struct CryptoService {
    private let key: SymmetricKey?

    init() {
        self.key = try? ObfuscatedKeyProvider.reconstructedSymmetricKey()
    }

    /// Encrypts a plaintext Data and returns Base64 string which encodes the combined sealed-box (nonce+ciphertext+tag)
    public func encryptToBase64(plaintext: Data) throws -> String {
        guard let key else {
            return ""
        }
        let sealedBox = try AES.GCM.seal(plaintext, using: key)
        // combined contains nonce + ciphertext + tag
        guard let combined = sealedBox.combined else {
            throw CryptoError.encodingFailed
        }
        return combined.base64EncodedString()
    }

    /// Convenience: encrypt a UTF-8 String -> Base64 ciphertext
    public func encryptToBase64(plaintext: String) throws -> String {
        guard let key else {
            return ""
        }
        guard let data = plaintext.data(using: .utf8) else { throw CryptoError.encodingFailed }
        return try encryptToBase64(plaintext: data)
    }

    /// Decrypts a Base64 combined sealed-box string and returns plaintext Data
    public func decryptBase64ToData(_ base64Combined: String) throws -> Data {
        guard let key else {
            return Data()
        }
        guard let combined = Data(base64Encoded: base64Combined) else {
            throw CryptoError.invalidCiphertext
        }
        let sealedBox = try AES.GCM.SealedBox(combined: combined)
        let decrypted = try AES.GCM.open(sealedBox, using: key)
        return decrypted
    }

    /// Decrypts a Base64 combined sealed-box dara and returns plaintext Data
    public func decryptBase64ToData(_ data: Data) throws -> Data {
        guard let key else {
            return Data()
        }

        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decrypted = try AES.GCM.open(sealedBox, using: key)
        return decrypted
    }

    /// Convenience: decrypt to UTF-8 String
    public func decryptBase64ToString(_ base64Combined: String) throws -> String {
        guard let key else {
            return ""
        }
        let data = try decryptBase64ToData(base64Combined)
        guard let str = String(data: data, encoding: .utf8) else {
            throw CryptoError.encodingFailed
        }
        return str
    }

    // MARK: - Errors
    public enum CryptoError: Error {
        case invalidKey
        case invalidCiphertext
        case encodingFailed
    }
}

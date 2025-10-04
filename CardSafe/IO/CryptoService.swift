import Foundation
import CryptoKit

/// Symmetric encryption service using AES-GCM (CryptoKit).
/// - Encrypts/decrypts Data or String and returns Base64 encoded strings for ciphertext.
public struct CryptoService {
    private let key: SymmetricKey

    init() {
        let passphraseData = Data(Self.ivArgument.utf8)
        let saltData = Data(Self.saltArgument.utf8)
        let key = HKDF<SHA512>.deriveKey(inputKeyMaterial: SymmetricKey(data: passphraseData), salt: saltData, info: Data(), outputByteCount: 32)
        self.key = key
    }

    private static var ivArgument: String {
        let args = ProcessInfo.processInfo.arguments
        if let keyIndex = args.firstIndex(of: "-EncryptionKey"),
           keyIndex + 1 < args.count {
            let passedKey = args[keyIndex + 1]
            return passedKey
        } else {
            return "SeC-rEt_EnCrYpTiOn_K3y"
        }
    }

    private static var saltArgument: String {
        let args = ProcessInfo.processInfo.arguments
        if let keyIndex = args.firstIndex(of: "-Salt"),
           keyIndex + 1 < args.count {
            let passedKey = args[keyIndex + 1]
            return passedKey
        } else {
            return "SaLt-PaSsP+hRa#Se"
        }
    }

    /// Encrypts a plaintext Data and returns Base64 string which encodes the combined sealed-box (nonce+ciphertext+tag)
    public func encryptToBase64(plaintext: Data) throws -> String {
        let sealedBox = try AES.GCM.seal(plaintext, using: key)
        // combined contains nonce + ciphertext + tag
        guard let combined = sealedBox.combined else {
            throw CryptoError.encodingFailed
        }
        return combined.base64EncodedString()
    }

    /// Convenience: encrypt a UTF-8 String -> Base64 ciphertext
    public func encryptToBase64(plaintext: String) throws -> String {
        guard let data = plaintext.data(using: .utf8) else { throw CryptoError.encodingFailed }
        return try encryptToBase64(plaintext: data)
    }

    /// Decrypts a Base64 combined sealed-box string and returns plaintext Data
    public func decryptBase64ToData(_ base64Combined: String) throws -> Data {
        guard let combined = Data(base64Encoded: base64Combined) else {
            throw CryptoError.invalidCiphertext
        }
        let sealedBox = try AES.GCM.SealedBox(combined: combined)
        let decrypted = try AES.GCM.open(sealedBox, using: key)
        return decrypted
    }

    /// Decrypts a Base64 combined sealed-box dara and returns plaintext Data
    public func decryptBase64ToData(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decrypted = try AES.GCM.open(sealedBox, using: key)
        return decrypted
    }

    /// Convenience: decrypt to UTF-8 String
    public func decryptBase64ToString(_ base64Combined: String) throws -> String {
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

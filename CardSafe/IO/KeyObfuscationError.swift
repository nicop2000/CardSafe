//
//  KeyObfuscationError.swift
//  CardSafe
//
//  Created by Nico Petersen on 03.10.25.
//


import Foundation
import CryptoKit
import CommonCrypto // make sure your project exposes CommonCrypto (Bridging header / modulemap if needed)


/// Errors
public enum KeyObfuscationError: Error {
    case invalidFragments
    case pbkdf2Failed(status: Int32)
    case invalidBase64Fragment(index: Int)
    case finalKeyLengthMismatch(expected: Int, got: Int)
}

fileprivate extension Data {
    /// XOR two Data blobs (truncates to the shorter length)
    func xor(with other: Data) -> Data {
        let n = Swift.min(self.count, other.count)
        var out = Data(count: n)
        for i in 0..<n {
            out[i] = self[i] ^ other[i]
        }
        return out
    }
    mutating func applyShift(from string: String) {
        let shiftBytes = [UInt8](string.utf8)
        guard !shiftBytes.isEmpty else { return }

        for i in 0..<self.count {
            // shift each byte by corresponding byte in the string (wrap around if needed)
            self[i] = self[i] &+ shiftBytes[i % shiftBytes.count]
        }
    }
}

/// - adjust iterations to taste (higher -> slower to brute force)
public struct ObfuscatedKeyProvider {
    // --- Example fragments (put these in different files if you want even better distribution) ---
    // These should LOOK random. In practice you'll generate the maskedKey offline, then split into fragments.
    // For demonstration we show three fragments of a base64-encoded masked key.
    private static let maskedKeyBase64Fragments: [String] = [
        // fragment 0
        "G6s8r2K1mVwxQ1Bz",
        // fragment 1
        "d7jK0x9pLq2aYmZt",
        // fragment 2
        "p4S8fY6uR0bM3NqU"
    ]

    // Passphrase fragments (should be less obvious words or small random strings)
    private static let passphraseFragments: [String] = [
        "frgA-",
        "pl3X",
        "-9z"
    ]

    // Baked-in salt (store somewhere else for slightly different distribution if desired)
    private static let saltBase64 = "c2FsdF9leGFtcGxlX2Jhc2U2NA==" // "salt_example_base64" as example

    /// Public: reconstruct SymmetricKey
    public static func reconstructedSymmetricKey() throws -> SymmetricKey {
        try reconstructedKeyData()
    }

    private static var ivArgument: String {
        let args = ProcessInfo.processInfo.arguments
        if let keyIndex = args.firstIndex(of: "-EncryptionKey"),
           keyIndex + 1 < args.count {
            let passedKey = args[keyIndex + 1]
            return passedKey
        } else {
            return ""
        }
    }

    /// Public: reconstruct raw key bytes
    private static func reconstructedKeyData() throws -> SymmetricKey {
        // 1) Join maskedKey fragments and decode base64
        let combinedBase64 = maskedKeyBase64Fragments.joined()
        guard let maskedKeyData = Data(base64Encoded: combinedBase64) else {
            // figure out which fragment failed (helpful while developing)
            for (i, frag) in maskedKeyBase64Fragments.enumerated() {
                if Data(base64Encoded: frag) == nil {
                    throw KeyObfuscationError.invalidBase64Fragment(index: i)
                }
            }
            throw KeyObfuscationError.invalidFragments
        }

        // 2) Rebuild passphrase from fragments
        let passphraseString = passphraseFragments.joined()
        guard let passphraseData = passphraseString.data(using: .utf8) else {
            throw KeyObfuscationError.invalidFragments
        }

        var keyData = passphraseData.xor(with: maskedKeyData) // simple obfu   scation step (XOR with constant)
        keyData.applyShift(from: ivArgument)
                                                   // 3) salt
        guard let saltData = Data(base64Encoded: saltBase64) else {
            throw KeyObfuscationError.invalidFragments
        }

        // 4) derive mask same length as maskedKey
        let key = HKDF<SHA512>.deriveKey(inputKeyMaterial: SymmetricKey(data: keyData), salt: saltData, info: Data(), outputByteCount: 32)
        return key
    }
}

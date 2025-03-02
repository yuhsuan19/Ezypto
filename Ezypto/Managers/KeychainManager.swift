//
//  KeychainManager.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import Foundation
import Security

protocol KeychainManagerProtocol {
    func saveMnemonicToKeychain(mnemonic: String) throws
    func loadMnemonicToKeychain() -> String?
}

final class KeychainManager {
    static let attrService: String = "ezypto.wallet"
    static let mnemonicAttrAccount: String = "user_mnemonic"

    // todo: encrypt(AES) with user password before saving
    func saveMnemonicToKeychain(mnemonic: String) throws {
        guard let mnemonicData = mnemonic.data(using: .utf8) else {
            throw KeychainManagerError.failToSaveMnemonic
        }

        let status = saveData(
            attrService: Self.attrService,
            attrAccount: Self.mnemonicAttrAccount,
            data: mnemonicData
        )
        if status != errSecSuccess {
            throw KeychainManagerError.failToSaveMnemonic
        }
    }

    func loadMnemonicToKeychain() -> String? {
        guard let data = loadData(attrService: Self.attrService, attrAccount: Self.mnemonicAttrAccount) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

extension KeychainManager {
    private func saveData(attrService: String, attrAccount: String, data: Data) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: attrService,
            kSecAttrAccount as String: attrAccount,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }

    private func loadData(attrService: String, attrAccount: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: attrService,
            kSecAttrAccount as String: attrAccount,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess else {
            return nil
        }
        return dataTypeRef as? Data
    }
}

// MARK: - Error
enum KeychainManagerError: Error {
    case failToSaveMnemonic
}

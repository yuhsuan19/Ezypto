//
//  WalletManager.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import Foundation
import web3swift
import Web3Core

final class WalletManager {

    let keystore: BIP32Keystore

    init(keystore: BIP32Keystore) {
        self.keystore = keystore
    }
}

// MARK: - Static functions
extension WalletManager {
    static func generate(mnemonics: String) throws -> WalletManager {
        do {
            // todo: generate keystore with password
            guard let keystore = try BIP32Keystore(mnemonics: mnemonics, password: "") else {
                throw KeystoreManagerError.failToGenerateKeystore
            }
            print("===keystore generated===")
            print("EVM address: \(String(describing: keystore.addresses?.first))")
            print("========================")
            return WalletManager(keystore: keystore)
        } catch {
            throw error
        }
    }
}

// MARK: - Error
enum KeystoreManagerError: Error {
    case failToGenerateKeystore
}

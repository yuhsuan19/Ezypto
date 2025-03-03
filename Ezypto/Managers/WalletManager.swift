//
//  WalletManager.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import Foundation
import web3swift
import Web3Core

protocol WalletManagerProtocol {
    func addresses() -> [EthereumAddress]?
    func address(at index: Int) -> EthereumAddress?
}

final class WalletManager: WalletManagerProtocol {

    private let keystore: BIP32Keystore

    init(keystore: BIP32Keystore) {
        self.keystore = keystore
    }

    func addresses() -> [EthereumAddress]? {
        return keystore.addresses
    }

    func address(at index: Int = 0) -> EthereumAddress? {
        return keystore.addresses?[safe: index]
    }

}

// MARK: - Static functions
extension WalletManager {
    static func generate(mnemonics: String?) throws -> WalletManager {
        guard let mnemonics, MnemonicsHelper.validate(mnemonics: mnemonics) else {
            throw WalletManagerError.invalidMnemonics
        }
        do {
            // todo: generate keystore with password
            guard let keystore = try BIP32Keystore(mnemonics: mnemonics, password: "") else {
                throw WalletManagerError.failToGenerateKeystore
            }
            print("===Keystore Generated===")
            print("EVM Address: \(String(describing: keystore.addresses?.first))")
            print("========================")
            return WalletManager(keystore: keystore)
        } catch {
            throw error
        }
    }
}

// MARK: - Error
enum WalletManagerError: Error {
    case invalidMnemonics
    case failToGenerateKeystore
}

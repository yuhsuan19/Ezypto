//
//  MockKeychainManager.swift
//  EzyptoTests
//
//  Created by Shane Chi on 2025/3/4.
//

@testable import Ezypto

final class MockKeychainManager: KeychainManagerProtocol {
    var savedMnemonic: String?
    var shouldThrowErrorOnSave = false

    func saveMnemonicsToKeychain(mnemonic: String) throws {
        savedMnemonic = mnemonic
    }

    func loadMnemonicsFromKeychain() -> String? {
        return savedMnemonic
    }

    func deleteMnemonicsFromKeychain() throws {
        savedMnemonic = nil
    }
}

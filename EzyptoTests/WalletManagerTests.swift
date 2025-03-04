//
//  WalletManagerTests.swift
//  EzyptoTests
//
//  Created by Shane Chi on 2025/3/4.
//

import XCTest
import Web3Core
@testable import Ezypto

final class WalletManagerTests: XCTestCase {

    func testGenerateWalletManager() {
        // Given
        let mnemonics = "unhappy nice extra alcohol vehicle control unable inmate tortoise alpha lend estate"

        do {
            // When
            let walletManager = try WalletManager.generate(mnemonics: mnemonics)

            // Then
            XCTAssertEqual(walletManager.address(at: 0), EthereumAddress("0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9")!)
            XCTAssertEqual(walletManager.addresses(), [EthereumAddress("0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9")!])
            XCTAssertEqual(walletManager.addressStringValue(at: 0), "0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9")
        } catch {
            XCTFail("WalletManager generation failed unexpectedly: \(error)")
        }
    }


    func testInvalidMnemonicsGenerateWalletManager() {
        // Given
        let invalidMnemonics = "invalid words for testing mnemonics"

        // When
        do {
            _ = try WalletManager.generate(mnemonics: invalidMnemonics)
            XCTFail("Expected to throw WalletManagerError.invalidMnemonics, but no error was thrown")
        } catch WalletManagerError.invalidMnemonics {
            // Then
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}

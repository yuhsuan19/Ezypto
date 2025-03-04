//
//  MnemonicsHelperTests.swift
//  EzyptoTests
//
//  Created by Shane Chi on 2025/2/28.
//

import XCTest
@testable import Ezypto

final class MnemonicsHelperTests: XCTestCase {

    func testValidMnemonics() {
        // Given
        let validMnemonics = "unhappy nice extra alcohol vehicle control unable inmate tortoise alpha lend estate"

        // When
        let isValid = MnemonicsHelper.validate(mnemonics: validMnemonics)

        // Then
        XCTAssertTrue(isValid, "Valid mnemonics should return true")
    }

    func testInvalidMnemonics() {
        // Given
        let invalidMnemonics = "invalid mnemonic phrase that is wrong"

        // When
        let isValid = MnemonicsHelper.validate(mnemonics: invalidMnemonics)

        // Then
        XCTAssertFalse(isValid, "Invalid mnemonics should return false")
    }

    func testSplitMnemonics() throws {
        // Given
        let mnemonics = "unhappy nice extra alcohol vehicle control unable inmate tortoise alpha lend estate"
        let expectedWords = ["unhappy", "nice", "extra", "alcohol", "vehicle", "control", "unable", "inmate", "tortoise", "alpha", "lend", "estate"]

        // When
        let result = try MnemonicsHelper.split(mnemonics: mnemonics)

        // Then
        XCTAssertEqual(result, expectedWords, "Split mnemonics should match the expected word array")
    }

    func testJoinMnemonics() throws {
        // Given
        let phrases = ["unhappy", "nice", "extra", "alcohol", "vehicle", "control", "unable", "inmate", "tortoise", "alpha", "lend", "estate"]
        let expectedMnemonics = "unhappy nice extra alcohol vehicle control unable inmate tortoise alpha lend estate"

        // When
        let result = try MnemonicsHelper.join(phrases: phrases)

        // Then
        XCTAssertEqual(result, expectedMnemonics, "Joined mnemonics should match the original phrase")
    }

    func testGenerateMnemonics() throws {
        // Given
        let entropy = 128

        // When
        let generatedPhrases = try MnemonicsHelper.generateRecoveryPhrases(entropy: entropy)

        // Then
        XCTAssertEqual(generatedPhrases.count, 12, "Generated mnemonics should have 12 words by default")
        XCTAssertTrue(MnemonicsHelper.validate(phrases: generatedPhrases), "Generated mnemonics should be valid")
    }

    func testInvalidJoinMnemonics() {
        // Given
        let invalidPhrases = ["invalid", "mnemonic", "phrase"]

        // When
        do {
            _ = try MnemonicsHelper.join(phrases: invalidPhrases)
        } catch MnemonicsHelperError.invalidMnemonics {
            // Then
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    func testInvalidSplitMnemonics() {
        // Given
        let invalidMnemonics = "invalid mnemonic phrase that is wrong"

        // When
        do {
            _ = try MnemonicsHelper.split(mnemonics: invalidMnemonics)
        } catch MnemonicsHelperError.invalidMnemonics {
            // Then
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}

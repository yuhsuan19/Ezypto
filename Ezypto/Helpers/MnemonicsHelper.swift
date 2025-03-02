//
//  MnemonicsHelper.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import Foundation
import Web3Core

struct MnemonicsHelper {
    static func validate(mnemonics: String, language: BIP39Language = .english) -> Bool {
        return BIP39.seedFromMmemonics(mnemonics, language: language)  != nil
    }

    static func join(phrases: [String], language: BIP39Language = .english) throws -> String {
        let joined = phrases.joined(separator: " ")
        guard Self.validate(mnemonics: joined, language: language) else {
            throw MnemonicsHelperError.invalidMnemonics
        }
        return phrases.joined(separator: " ")
    }

    static func validate(phrases: [String], language: BIP39Language = .english) -> Bool {
        guard let _ = try? Self.join(phrases: phrases, language: language) else {
            return false
        }
        return true
    }

    static func split(mnemonics: String, language: BIP39Language = .english) throws -> [String] {
        guard Self.validate(mnemonics: mnemonics, language: language) else {
            throw MnemonicsHelperError.invalidMnemonics
        }
        return mnemonics.split(separator: " ").map { String($0) }
    }

    static func generateRecoveryPhrases(entropy: Int = 128, language: BIP39Language = .english) throws -> [String] {
        do {
           return try BIP39.generateMnemonics(entropy: entropy, language: language)
        } catch {
            throw error
        }
    }
}

// MAEK: - Error
enum MnemonicsHelperError: Error {
    case invalidMnemonics
}

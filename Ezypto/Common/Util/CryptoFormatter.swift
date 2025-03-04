//
//  CryptoFormatter.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/4.
//

import Foundation
import BigInt

final class CryptoNumberFormatter {

    static let full = CryptoNumberFormatter()
    static let short: CryptoNumberFormatter = {
        let formatter = CryptoNumberFormatter()
        formatter.maximumFractionDigits = 4
        return formatter
    }()


    var minimumFractionDigits = 0
    var maximumFractionDigits: Int

    var decimalSeparator: String
    var groupingSeparator: String

    let locale: Locale

    init(maximumFractionDigits: Int = Int.max, locale: Locale = .current) {
        self.maximumFractionDigits = maximumFractionDigits
        self.locale = locale
        self.decimalSeparator = locale.decimalSeparator ?? "."
        self.groupingSeparator = locale.groupingSeparator ?? ","
    }

    func number(from string: String, decimals: Int) -> BigInt? {
        guard let index = string.firstIndex(where: { String($0) == decimalSeparator }) else {
            // No fractional part
            return BigInt(string).flatMap { $0 * BigInt(10).power(decimals) }
        }

        let fractionalDigits = string.distance(from: string.index(after: index), to: string.endIndex)

        var fullString = string
        fullString.remove(at: index)

        let droppedDigits = fractionalDigits - decimals
        if droppedDigits > 0 {
            fullString = String(fullString.dropLast(droppedDigits))
        }

        guard let number = BigInt(fullString) else {
            return nil
        }

        if fractionalDigits < decimals {
            return number * BigInt(10).power(decimals - fractionalDigits)
        } else {
            return number
        }
    }

    func string(from number: BigInt, decimals: Int32) -> String {
        string(from: number, decimals: Int(decimals))
    }

    func string(from number: BigInt, decimals: Int, showSign: Bool = false) -> String {
        precondition(minimumFractionDigits >= 0)
        precondition(maximumFractionDigits >= 0)

        let dividend = BigInt(10).power(decimals)
        let (integerPart, remainder) = number.quotientAndRemainder(dividingBy: dividend)
        let sign = integerPart.sign == .minus ? "-" : "+"
        let prefix = showSign ? sign : ""
        let integerString = integerString(from: BigInt(integerPart.magnitude))
        let fractionalString = fractionalString(from: BigInt(sign: .plus, magnitude: remainder.magnitude), decimals: decimals)
        if fractionalString.isEmpty {
            return "\(prefix)\(integerString)"
        }
        return "\(prefix)\(integerString)\(decimalSeparator)\(fractionalString)"
    }

    func decimal(from number: BigInt, decimals: Int) -> Decimal? {
        precondition(minimumFractionDigits >= 0)
        precondition(maximumFractionDigits >= 0)
        let dividend = BigInt(10).power(decimals)
        let (integerPart, remainder) = number.quotientAndRemainder(dividingBy: dividend)
        let integerString = integerPart.description
        let fractionalString = fractionalString(from: BigInt(sign: .plus, magnitude: remainder.magnitude), decimals: decimals)
        if fractionalString.isEmpty {
            return Decimal(string: integerString)
        }
        return Decimal(string: "\(integerString)\(decimalSeparator)\(fractionalString)", locale: locale)
    }
}

// MARK: - Private functions
extension CryptoNumberFormatter {
    private func integerString(from: BigInt) -> String {
        var string = from.description
        let end = from.sign == .minus ? 1 : 0
        for offset in stride(from: string.count - 3, to: end, by: -3) {
            let index = string.index(string.startIndex, offsetBy: offset)
            string.insert(contentsOf: groupingSeparator, at: index)
        }
        return string
    }

    private func fractionalString(from number: BigInt, decimals: Int) -> String {
        var number = number
        let digits = number.description.count

        if number == 0 || decimals - digits >= maximumFractionDigits {
            // Value is smaller than can be represented with `maximumFractionDigits`
            return String(repeating: "0", count: minimumFractionDigits)
        }

        if decimals < minimumFractionDigits {
            number *= BigInt(10).power(minimumFractionDigits - decimals)
        }
        if decimals > maximumFractionDigits {
            number /= BigInt(10).power(decimals - maximumFractionDigits)
        }

        var string = number.description
        if digits < decimals {
            // Pad with zeros at the left if necessary
            string = String(repeating: "0", count: decimals - digits) + string
        }

        // Remove extra zeros after the decimal point.
        if let lastNonZeroIndex = string.reversed().firstIndex(where: { $0 != "0" })?.base {
            let numberOfZeros = string.distance(from: string.startIndex, to: lastNonZeroIndex)
            if numberOfZeros > minimumFractionDigits {
                let newEndIndex = string.index(string.startIndex, offsetBy: numberOfZeros - minimumFractionDigits)
                string = String(string[string.startIndex ..< newEndIndex])
            }
        }

        return string
    }

}

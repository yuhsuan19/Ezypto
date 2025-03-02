//
//  CreateWalletViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import UIKit
import RxSwift
import RxRelay

final class CreateWalletViewModel {
    let recoveryPhrasesRelay: BehaviorRelay<[String]> = .init(value: [])

    init() {
        generatePhrases()
    }

    func numberOfItems() -> Int {
        return recoveryPhrasesRelay.value.count
    }

    func displayModel(at index: Int) -> String {
        return "\(index+1). \(recoveryPhrasesRelay.value[index])"
    }

    func copyMnemonics() {
        do {
            let mnemonics = try MnemonicsHelper.join(phrases: recoveryPhrasesRelay.value)
            UIPasteboard.general.string = mnemonics
        } catch {
            // todo: handle error
            print(error)
        }
    }
}

// MARK: - Private functions
extension CreateWalletViewModel {

    private func generatePhrases() {
        do {
            let phrases = try MnemonicsHelper.generateRecoveryPhrases()
            recoveryPhrasesRelay.accept(phrases)
        } catch {
            // todo: handle error
            print(error)
        }
    }
}

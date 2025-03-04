//
//  AccountViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit
import RxSwift
import RxRelay

final class AccountViewModel {

    let walletRemovedSubject: PublishSubject<Void> = .init()
    let displayRecoverPhrasesRelay: BehaviorRelay<Bool> = .init(value: false)
    let recoveryPhrasesRelay: BehaviorRelay<[String]> = .init(value: [])

    private let walletManager: WalletManagerProtocol
    private let keychainManager: KeychainManagerProtocol

    init(
        walletManager: WalletManagerProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.walletManager = walletManager
        self.keychainManager = keychainManager

        loadRecoveryPhrases()
    }

    func displayedAddress() -> String? {
        return walletManager.addressStringValue()
    }

    func copyAddress() {
        UIPasteboard.general.string = walletManager.addressStringValue()
    }

    func toggleDisplayRecoveryPhrases() {
        displayRecoverPhrasesRelay.accept(!displayRecoverPhrasesRelay.value)
    }

    func removeWallet() {
        do {
            try keychainManager.deleteMnemonicsFromKeychain()
            walletRemovedSubject.onNext(())
        } catch {
            // todo: error handle
            print(error)
        }
    }

    func numberOfItems() -> Int {
        return recoveryPhrasesRelay.value.count
    }

    func displayModel(at index: Int) -> String {
        return "\(index+1). \(recoveryPhrasesRelay.value[index])"
    }
}

// MARK: - Private functions
extension AccountViewModel {
    private func loadRecoveryPhrases() {
        guard let mnemonics = keychainManager.loadMnemonicsFromKeychain(),
              let phrases = try? MnemonicsHelper.split(mnemonics: mnemonics) else {
            return
        }
        recoveryPhrasesRelay.accept(phrases)
    }
}

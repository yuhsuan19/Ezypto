//
//  AccountViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit
import RxSwift

final class AccountViewModel {

    let walletRemovedSubject: PublishSubject<Void> = .init()

    private let walletManager: WalletManagerProtocol
    private let keychainManager: KeychainManagerProtocol

    init(
        walletManager: WalletManagerProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.walletManager = walletManager
        self.keychainManager = keychainManager
    }

    func displayedAddress() -> String? {
        return walletManager.addressStringValue()
    }

    func copyAddress() {
        UIPasteboard.general.string = walletManager.addressStringValue()
    }

    func removeWallet() {
        do {
            try keychainManager.deleteMnemonicFromKeychain()
            walletRemovedSubject.onNext(())
        } catch {
            // todo: error handle
            print(error)
        }
    }
}

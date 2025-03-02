//
//  SplashViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import Foundation
import RxSwift

final class SplashViewModel {

    let generateWalletManagerResultSubject: PublishSubject<Result<WalletManager, Error>> = .init()

    private let keychainManager: KeychainManager

    init(keychainManager: KeychainManager = KeychainManager()) {
        self.keychainManager = keychainManager
    }

    func prepareWallet() {
        do {
            let mnemonic = keychainManager.loadMnemonicToKeychain()
            let walletManager = try WalletManager.generate(mnemonics: mnemonic)
            generateWalletManagerResultSubject.onNext(.success(walletManager))
        } catch {
            generateWalletManagerResultSubject.onNext(.failure(error))
        }
    }
}

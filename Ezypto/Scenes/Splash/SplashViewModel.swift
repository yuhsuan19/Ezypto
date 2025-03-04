//
//  SplashViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import Foundation
import RxSwift

final class SplashViewModel: WalletManagerPrepareProtocol {

    let generateWalletManagerResultSubject: PublishSubject<Result<WalletManagerProtocol, Error>> = .init()
    
    let keychainManager: KeychainManagerProtocol

    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
}

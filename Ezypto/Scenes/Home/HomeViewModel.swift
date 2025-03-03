//
//  HomeViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import Foundation
import RxRelay
import RxSwift

final class HomeViewModel {
    let blockchainRelay: BehaviorRelay<Blockchain> = .init(value: .sepoliaEthereum)

    private let walletManager: WalletManagerProtocol

    init(walletManager: WalletManagerProtocol) {
        self.walletManager = walletManager
    }
}

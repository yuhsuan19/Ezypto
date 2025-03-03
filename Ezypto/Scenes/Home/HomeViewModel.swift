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

    let blockchainRelay: BehaviorRelay<Blockchain> = .init(value: .sepoliaEthereum) // todo: support change blockchain
    let selectedAddressIndexRelay: BehaviorRelay<Int> = .init(value: 0) // todo: support change address

    private let walletManager: WalletManagerProtocol

    init(walletManager: WalletManagerProtocol) {
        self.walletManager = walletManager
    }

    func displayedAddress() -> String? {
        walletManager.addressStringValue(at: selectedAddressIndexRelay.value)?.truncatingMiddle()
    }
}

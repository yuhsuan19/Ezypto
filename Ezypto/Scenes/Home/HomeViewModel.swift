//
//  HomeViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import Foundation
import RxRelay
import RxSwift
import web3swift
import Web3Core

final class HomeViewModel {

    let blockchainRelay: BehaviorRelay<Blockchain> = .init(value: .sepoliaEthereum) // todo: support change blockchain

    private let walletManager: WalletManagerProtocol
    private let blockchainInteractionProvider: BlockchainInteractionProvider

    private let disposeBag = DisposeBag()

    init(
        walletManager: WalletManagerProtocol,
        blockchainInteractionProvider: BlockchainInteractionProvider = BlockchainInteractionProvider()
    ) {
        self.walletManager = walletManager
        self.blockchainInteractionProvider = blockchainInteractionProvider

        setUpBindings()
    }

    func displayedAddress() -> String? {
        walletManager.addressStringValue()?.truncatingMiddle()
    }
}

extension HomeViewModel {
    private func setUpBindings() {
        blockchainRelay.subscribe(onNext: { [weak self] _ in
            self?.setUpBlockchainInteractionProvider()
        })
        .disposed(by: disposeBag)
    }

    private func setUpBlockchainInteractionProvider() {
        Task {
            do {
                try await blockchainInteractionProvider.setUpWeb3Client(
                    keystore: KeystoreManager([walletManager.keystore]),
                    blockchain: blockchainRelay.value
                )

                try await blockchainInteractionProvider.getNativeTokenBalance(of: walletManager.address()!)

                try await blockchainInteractionProvider.sendNativeToken(from: walletManager.address()!, keystore: walletManager.keystore)

                try await blockchainInteractionProvider.getNativeTokenBalance(of: walletManager.address()!)

            } catch {
                // todo: error handle
                print(error)
            }
        }
    }
}

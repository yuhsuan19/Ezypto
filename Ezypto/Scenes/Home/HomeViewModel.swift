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
import BigInt

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

                let hash = try await blockchainInteractionProvider.sendNativeToken(
                    from: walletManager.address()!,
                    to: EthereumAddress("0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9")!,
                    value: BigUInt("0.01", .ether)!
                )
                print(hash)


            } catch {
                // todo: error handle
                print(error)
            }
        }
    }
}

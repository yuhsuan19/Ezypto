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
    let nativeBalanceRelay: BehaviorRelay<String> = .init(value: "-.-")

    private let walletManager: WalletManagerProtocol
    private let blockchainInteractionProvider: BlockchainInteractionProvider

    private let disposeBag = DisposeBag()
    private var nativeTokenBalancePollingDisposable: Disposable?

    init(
        walletManager: WalletManagerProtocol,
        blockchainInteractionProvider: BlockchainInteractionProvider = BlockchainInteractionProvider()
    ) {
        self.walletManager = walletManager
        self.blockchainInteractionProvider = blockchainInteractionProvider
        setUpBlockchainInteractionProvider()

        setUpBindings()
    }

    func loadData() {

    }

    func displayedAddress() -> String? {
        walletManager.addressStringValue()?.truncatingMiddle()
    }

    func nativeTokenSymbol() -> String {
        blockchainRelay.value.nativeTokenSymbol
    }
}

extension HomeViewModel {
    private func setUpBindings() {
        blockchainRelay
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
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
                pollingNativeTokenBalance()
            } catch {
                // todo: error handle
                print(error)
            }
        }
    }

    private func pollingNativeTokenBalance() {
        nativeTokenBalancePollingDisposable?.dispose()

        fetchNativeTokenBalance()
        nativeTokenBalancePollingDisposable = Observable<Int>.interval(DispatchTimeInterval.seconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.fetchNativeTokenBalance()
            })
        nativeTokenBalancePollingDisposable?.disposed(by: disposeBag)
    }

    private func fetchNativeTokenBalance() {
        guard let address = walletManager.address() else { return }
        Task {
            do {
                let balance = try await blockchainInteractionProvider.getNativeTokenBalance(of: address)
                let formatted = CryptoNumberFormatter.short.string(from: BigInt(balance), decimals: 18)
                nativeBalanceRelay.accept(formatted)

                print("Native token balance fetched: \(formatted)")
            } catch {
                nativeBalanceRelay.accept("-.-")
            }
        }
    }
}

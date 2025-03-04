//
//  WalletManagerGenrating.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/4.
//

import UIKit
import RxSwift

// MARK: - For UIViewController
protocol WalletManagerPrepareViewControllerProtocol: UIViewController {
    associatedtype ViewModelType: WalletManagerPrepareProtocol

    var onCompleted: ((WalletManagerProtocol?) -> Void)? { get }
    var viewModel: ViewModelType { get }

    func setUpWalletManagerGeneratingBindings()
}

extension WalletManagerPrepareViewControllerProtocol {
    func setUpWalletManagerGeneratingBindings() {
        _ = viewModel.generateWalletManagerResultSubject
            .observe(on: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .success(walletManger):
                    self?.onCompleted?(walletManger)
                case .failure:
                    self?.onCompleted?(nil)
                }
            })
    }
}

// MARK: - For ViewModel
protocol WalletManagerPrepareProtocol {
    var generateWalletManagerResultSubject: PublishSubject<Result<WalletManagerProtocol, Error>> { get }
    var keychainManager: KeychainManagerProtocol { get }

    func prepareWallet()
}

extension WalletManagerPrepareProtocol {
    func prepareWallet() {
        do {
            let mnemonic = keychainManager.loadMnemonicsFromKeychain()
            let walletManager = try WalletManager.generate(mnemonics: mnemonic)
            generateWalletManagerResultSubject.onNext(.success(walletManager))
        } catch {
            generateWalletManagerResultSubject.onNext(.failure(error))
        }
    }
}

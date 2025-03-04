//
//  AccountCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit

final class AccountCoordinator: Coordinator, Presentable {

    var onLogout: (() -> Void)?

    private let walletManager: WalletManagerProtocol

    private let router: NavigationRouter

    private lazy var accountViewController: AccountViewController = {
        let viewModel = AccountViewModel(walletManager: walletManager)
        let viewController = AccountViewController(viewModel: viewModel)
        viewController.onRoute = { [weak self] route in
            switch route {
            case .back:
                self?.router.popModule(animated: true)
            }
        }
        viewController.onLogout = { [weak self] in
            self?.onLogout?()
        }
        return viewController
    }()

    init(
        walletManager: WalletManagerProtocol,
        router: NavigationRouter = NavigationRouter()
    ) {
        self.walletManager = walletManager
        self.router = router
    }

    func toPresentable() -> UIViewController {
        return accountViewController
    }
}

//
//  HomeCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class HomeCoordinator: Coordinator, Presentable {

    private let router: NavigationRouter
    private let walletManager: WalletManagerProtocol

    private lazy var homeViewController: HomeViewController = {
        let viewModel = HomeViewModel(walletManager: walletManager)
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.onRoute = { [weak self] route in
            switch route {
            case .account:
                self?.routeToAccount()
            }
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

    func start() {
        router.setRootModule(homeViewController, hideBar: false)
    }

    func toPresentable() -> UIViewController {
        router.toPresentable()
    }
}

// MARK: - Routings
extension HomeCoordinator {

    private func routeToAccount() {
        let coordinator = AccountCoordinator(walletManager: walletManager, router: router)
        addChild(coordinator)
        router.push(coordinator, animated: true) { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }

}

//
//  WelcomeCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class WelcomeCoordinator: Coordinator, Presentable {

    var onRoute: ((Route) -> Void)?

    private let keychainManager: KeychainManagerProtocol
    private let router: NavigationRouter

    private lazy var welcomeViewController: WelcomeViewController = {
        let viewController = WelcomeViewController()
        viewController.onRoute = { [weak self] route in
            switch route {
            case .createWallet:
                self?.routeToCreateWallet()
            case .importWallet:
                self?.routeToImportWallet()
            }
        }
        return viewController
    }()

    init(
        keychainManager: KeychainManagerProtocol,
        router: NavigationRouter = NavigationRouter()
    ) {
        self.keychainManager = keychainManager
        self.router = router
    }

    func start() {
        router.setRootModule(welcomeViewController, hideBar: true)
    }

    func toPresentable() -> UIViewController {
        router.toPresentable()
    }
}

// MARK: - Routings
extension WelcomeCoordinator {
    private func routeToCreateWallet() {
        let coordinator = CreateWalletCoordinator(
            keychainManager: keychainManager,
            router: router
        )
        coordinator.onCompleted = { [weak self] walletManager in
            if let walletManager {
                self?.onRoute?(.home(walletManager: walletManager))
            }
        }
        addChild(coordinator)
        router.push(coordinator, animated: true) { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }

    private func routeToImportWallet() {
        let coordinator = ImportWalletCoordinator(
            keychainManager: keychainManager,
            router: router
        )
        coordinator.onCompleted = { [weak self] walletManager in
            if let walletManager {
                self?.onRoute?(.home(walletManager: walletManager))
            }
        }
        addChild(coordinator)
        router.push(coordinator, animated: true) { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
}


// MARK: - Route
extension WelcomeCoordinator {
    enum Route {
        case home(walletManager: WalletManagerProtocol)
    }
}

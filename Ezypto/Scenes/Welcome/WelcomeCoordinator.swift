//
//  WelcomeCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class WelcomeCoordinator: Coordinator, Presentable {

    var onRoute: ((Route) -> Void)?

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

    init(router: NavigationRouter = NavigationRouter()) {
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
        let coordinator = CreateWalletCoordinator(router: router)
        addChild(coordinator)
        router.push(coordinator, animated: true) { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }

    private func routeToImportWallet() {
        let coordinator = ImportWalletCoordinator(router: router)
        addChild(coordinator)
        router.push(coordinator, animated: true) { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
}


// MARK: - Route
extension WelcomeCoordinator {
    enum Route {
        case home
    }
}

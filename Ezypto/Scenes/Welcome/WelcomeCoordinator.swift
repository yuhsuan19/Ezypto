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
                break
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
        onRoute?(.home)
    }
}


// MARK: - Route
extension WelcomeCoordinator {
    enum Route {
        case home
    }
}

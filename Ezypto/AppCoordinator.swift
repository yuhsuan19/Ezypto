//
//  AppCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    func start() {
        window.rootViewController = prepareSplashScene()
        window.makeKeyAndVisible()
    }
}

// MARK: - Private functions
extension AppCoordinator {
    private func startApp() {
        // check key store manager
    }

    private func prepareSplashScene() -> SplashViewController {
        let viewModel = SplashViewModel()
        let viewController = SplashViewController(viewModel: viewModel)
        return viewController
    }
}

// MARK: - Routing
extension AppCoordinator {
    private func routeToWelcome() {
        removeAllChildren()

        let coordinator = WelcomeCoordinator()
        coordinator.start()
        coordinator.onRoute = { [weak self] route in
            switch route {
            case .home:
                self?.routeToHome()
            }
        }
        addChild(coordinator)

        window.rootViewController = coordinator.toPresentable()
    }

    private func routeToHome() {
        removeAllChildren()

        let coordinator = HomeCoordinator()
        coordinator.start()
        addChild(coordinator)

        window.rootViewController = coordinator.toPresentable()
    }
}

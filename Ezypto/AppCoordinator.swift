//
//  AppCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow
    private let keychainManager: KeychainManagerProtocol

    init(
        window: UIWindow,
        keychainManager: KeychainManagerProtocol = KeychainManager()
    ) {
        self.window = window
        self.keychainManager = keychainManager
        super.init()
    }

    func start() {
        window.rootViewController = prepareSplashScene()
        window.makeKeyAndVisible()
    }
}

// MARK: - Private functions
extension AppCoordinator {
    private func prepareSplashScene() -> SplashViewController {
        let viewModel = SplashViewModel(keychainManager: keychainManager)
        let viewController = SplashViewController(viewModel: viewModel)
        viewController.onCompleted = { [weak self] walletManager in
            if let walletManager {
                self?.routeToHome(walletManager: walletManager)
            } else {
                self?.routeToWelcome()
            }
        }
        return viewController
    }
}

// MARK: - Routing
extension AppCoordinator {
    private func routeToWelcome() {
        removeAllChildren()

        let coordinator = WelcomeCoordinator(keychainManager: keychainManager)
        coordinator.onRoute = { [weak self] route in
            switch route {
            case let .home(walletManager):
                self?.routeToHome(walletManager: walletManager)
            }
        }

        coordinator.start()
        addChild(coordinator)

        window.rootViewController = coordinator.toPresentable()
    }

    private func routeToHome(walletManager: WalletManagerProtocol) {
        removeAllChildren()

        let coordinator = HomeCoordinator(
            walletManager: walletManager,
            keychainManager: keychainManager
        )
        coordinator.onLogout = { [weak self] in
            self?.routeToWelcome()
        }
        
        coordinator.start()
        addChild(coordinator)

        window.rootViewController = coordinator.toPresentable()
    }
}

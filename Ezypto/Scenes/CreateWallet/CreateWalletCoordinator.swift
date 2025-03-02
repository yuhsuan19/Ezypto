//
//  CreateWalletCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import UIKit

final class CreateWalletCoordinator: Coordinator, Presentable {

    private let router: NavigationRouter

    private lazy var createWalletViewController: UIViewController = {
        let viewModel = CreateWalletViewModel()
        let viewController = CreateWalletViewController(viewModel: viewModel)
        viewController.onRoute = { [weak self] route in
            switch route {
            case .back:
                self?.router.popModule(animated: true)
            }
        }
        return viewController
    }()

    init(router: NavigationRouter) {
        self.router = router
    }

    func toPresentable() -> UIViewController {
        return createWalletViewController
    }
}

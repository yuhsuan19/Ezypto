//
//  ImportWalletCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class ImportWalletCoordinator: Coordinator, Presentable {

    private let router: NavigationRouter

    private lazy var importWalletViewController: UIViewController = {
        let viewModel = ImportWalletViewModel()
        let viewController = ImportWalletViewController(viewModel: viewModel)
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
        return importWalletViewController
    }
}

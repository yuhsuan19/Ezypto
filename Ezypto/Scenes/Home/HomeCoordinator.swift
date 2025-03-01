//
//  HomeCoordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class HomeCoordinator: Coordinator, Presentable {

    private let router: NavigationRouter

    private lazy var homeViewController: HomeViewController = {
        let viewController = HomeViewController()
        return viewController
    }()

    init(router: NavigationRouter = NavigationRouter()) {
        self.router = router
    }

    func start() {
        router.setRootModule(homeViewController, hideBar: false)
    }

    func toPresentable() -> UIViewController {
        router.toPresentable()
    }
}

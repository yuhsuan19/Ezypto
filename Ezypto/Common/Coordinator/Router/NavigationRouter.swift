//
//  NavigationRouter.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class NavigationRouter: NSObject, NavigationRouterType {

    let navigationController: UINavigationController

    var rootViewController: UIViewController? { navigationController.viewControllers.first }

    private var poppedCompletions: [UIViewController: () -> Void]
    private let hidesAllBottomBarWhenPush: Bool

    init(
        navigationController: UINavigationController = UINavigationController(),
        hidesAllBottomBarWhenPush: Bool = false
    ) {
        self.navigationController = navigationController
        self.hidesAllBottomBarWhenPush = hidesAllBottomBarWhenPush
        self.poppedCompletions = [:]
    }

    func toPresentable() -> UIViewController {
        return navigationController
    }

    func setRootModule(_ module: Presentable, hideBar: Bool) {
        poppedCompletions.forEach { $0.value() }
        navigationController.setViewControllers([module.toPresentable()], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }

    func push(_ module: Presentable, animated: Bool, poppedCompletion: (() -> Void)?) {
        let controller = module.toPresentable()
        guard !(controller is UINavigationController) else { return }

        if let completion = poppedCompletion {
            poppedCompletions[controller] = completion
        }

        if hidesAllBottomBarWhenPush {
            controller.hidesBottomBarWhenPushed = true
        }

        navigationController.pushViewController(controller, animated: animated)
    }

    func popModule(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }

    func present(
        _ module: Presentable,
        animated: Bool,
        isFromTopViewController: Bool,
        completion: (() -> Void)?
    ) {
        let presentingViewController = navigationController.tabBarController ?? navigationController
        if isFromTopViewController {
            presentingViewController.topPresentedViewController.present(
                module.toPresentable(),
                animated: animated,
                completion: completion
            )
        } else {
            presentingViewController.present(
                module.toPresentable(),
                animated: animated,
                completion: completion
            )
        }
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        if navigationController.presentedViewController != nil {
            navigationController.dismiss(animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
}

// MARK: - Private functions
extension NavigationRouter {
    private func runCompletion(for controller: UIViewController) {
        guard let completion = poppedCompletions[controller] else { return }
        completion()
        poppedCompletions.removeValue(forKey: controller)
    }
}

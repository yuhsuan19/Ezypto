//
//  NavigationRouterType.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

protocol NavigationRouterType: RouterType {
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }

    func setRootModule(_ module: Presentable, hideBar: Bool)
    func push(_ module: Presentable, animated: Bool, poppedCompletion: (() -> Void)?)
    func popModule(animated: Bool)
    func popToRootModule(animated: Bool)
}

//
//  Presentable.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

public protocol Presentable {
    func toPresentable() -> UIViewController
    func dismissPresentable(animated: Bool, completion: (() -> Void)?)
}

extension Presentable {
    public func dismissPresentable(animated: Bool, completion: (() -> Void)?) {
        if let presentingViewController = toPresentable().presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
}

// MARK: - UIViewController + Presentable

extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        self
    }
}

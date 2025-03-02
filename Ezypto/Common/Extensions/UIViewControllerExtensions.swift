//
//  UIViewController+Extensions.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

extension UIViewController {
    var topPresentedViewController: UIViewController {
        var current: UIViewController = self
        while let presentedViewController = current.presentedViewController {
            current = presentedViewController
        }
        return current
    }
}

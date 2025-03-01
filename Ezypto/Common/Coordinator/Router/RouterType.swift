//
//  Router.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import Foundation

protocol RouterType: Presentable {
    func present(
        _ module: Presentable,
        animated: Bool,
        isFromTopViewController: Bool,
        completion: (() -> Void)?
    )

    func dismissModule(animated: Bool, completion: (() -> Void)?)
}

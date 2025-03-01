//
//  Coordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import Foundation

class Coordinator: NSObject {

    var children: [Coordinator] = []

    func addChild(_ coordinator: Coordinator) {
        children.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator,
            let index = children.firstIndex(of: coordinator)
        else {
            return
        }

        children.remove(at: index)
    }

    func removeAllChildren() {
        children.removeAll()
    }
}

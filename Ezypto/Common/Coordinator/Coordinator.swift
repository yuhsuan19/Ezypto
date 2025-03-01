//
//  Coordinator.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import Foundation

class Coordinator: NSObject {

    public var children: [Coordinator] = []

    public func addChild(_ coordinator: Coordinator) {
        children.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator,
            let index = children.firstIndex(of: coordinator)
        else {
            return
        }

        children.remove(at: index)
    }

    public func removeAllChildren() {
        children.removeAll()
    }
}

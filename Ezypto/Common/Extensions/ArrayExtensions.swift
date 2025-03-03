//
//  ArrayExtensions.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        (index >= 0 && index < count) ? self[index] : nil
    }
}

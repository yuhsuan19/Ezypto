//
//  StringExtension.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import UIKit

extension String {
    func widthOf(_ font: UIFont) -> CGFloat {
        return self.size(withAttributes: [NSAttributedString.Key.font: font]).width
    }

    func truncatingMiddle(first: Int = 6, last: Int = 6) -> String {
        if count > first + last {
            let first = self[..<index(startIndex, offsetBy: first)]
            let last = self[index(endIndex, offsetBy: -last)...]
            return "\(first)...\(last)"
        } else {
            return self
        }
    }
}

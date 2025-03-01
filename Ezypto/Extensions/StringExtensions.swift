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
}

//
//  BackButton.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class BackButton: UIButton {
    init() {
        super.init(frame: .zero)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private functions
extension BackButton {
    private func setUpViews() {
        snp.makeConstraints {
            $0.height.width.equalTo(32)
        }
        setImage(UIImage(named: "back"), for: .normal)
    }
}

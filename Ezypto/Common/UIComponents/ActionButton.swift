//
//  ActionButton.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit

final class ActionButton: UIButton {

    private let style: Style

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setUpViews()
    }

    convenience init(style: Style, title: String) {
        self.init(style: style)
        self.setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private functions
extension ActionButton {
    private func setUpViews() {
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
        layer.cornerRadius = 6

        setTitleColor(style.titleColor, for: .normal)
        backgroundColor = style.backgroundColor
    }
}


// MARK: - Style
extension ActionButton {
    enum Style {
        case full
        case plain

        var titleColor: UIColor {
            switch self {
            case .full:
                return .white
            case .plain:
                return AppColor.darkSub
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .full:
                return AppColor.darkSub
            case .plain:
                return .clear
            }
        }
    }
}

//
//  PhraseCollectionViewCell.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit
import Reusable

enum PhraseCollectionViewCellUX {
    static let font: UIFont = .systemFont(ofSize: 12, weight: .medium)
    static let hPadding: CGFloat = 24
    static let height: CGFloat = 42
}

final class PhraseCollectionViewCell: UICollectionViewCell {

    private lazy var phraseLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.darkSub
        label.font = PhraseCollectionViewCellUX.font
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(phrase: String) {
        phraseLabel.text = phrase
    }
}

// MARK: - Private functions
extension PhraseCollectionViewCell {
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.layer.borderColor = AppColor.darkSub.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = PhraseCollectionViewCellUX.height / 2

        contentView.addSubview(phraseLabel)
        phraseLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Reusable
extension PhraseCollectionViewCell: Reusable {}

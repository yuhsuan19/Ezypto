//
//  BlockchainChipView.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit
import RxCocoa
import RxSwift

fileprivate enum UX {
    static let height: CGFloat = 30
}

final class BlockchainChipView: TappableView {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.mainText
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()

    private lazy var dropDownImageView: UIImageView = {
        let imageView = UIImageView(image: .arrowDown)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0.6
        return imageView
    }()

    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, nameLabel, dropDownImageView])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.setCustomSpacing(6, after: nameLabel)
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    func update(blockchain: Blockchain) {
        logoImageView.image = UIImage(named: blockchain.logoImageName)
        nameLabel.text = blockchain.displayName
    }

    override func setUpViews() {
        super.setUpViews()
        
        snp.makeConstraints {
            $0.height.equalTo(UX.height)
        }

        backgroundColor = .white
        layer.cornerRadius = UX.height * 0.5

        logoImageView.snp.makeConstraints {
            $0.size.equalTo(UX.height * 0.6)
        }
        logoImageView.layer.cornerRadius = UX.height * 0.6 * 0.5

        dropDownImageView.snp.makeConstraints {
            $0.size.equalTo(UX.height * 0.6)
        }

        addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
}

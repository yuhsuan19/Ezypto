//
//  AddressChipView.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit
import RxCocoa
import RxSwift

final class AddressChipView: TappableView {

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.darkSub
        label.font = .systemFont(ofSize: 14, weight: .black)
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow-right"))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0.85
        return imageView
    }()

    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressLabel, arrowImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    func update(displayAddress: String?) {
        addressLabel.text = displayAddress
    }

    override func setUpViews() {
        super.setUpViews()

        backgroundColor = .clear

        snp.makeConstraints {
            $0.height.equalTo(30)
        }

        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
}

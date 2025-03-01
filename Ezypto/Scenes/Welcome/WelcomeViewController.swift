//
//  WelcomeViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/2/28.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to"
        return label
    }()

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ezypto"
        return label
    }()

    private lazy var welcomeLabelVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, appNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var createNewWalletButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create a new wallet", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()

    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createNewWalletButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

}

// MARK: - Private functions
extension WelcomeViewController {
    private func setUpViews() {
        view.backgroundColor = .white

        view.addSubview(welcomeLabelVStackView)
        welcomeLabelVStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
        }

        view.addSubview(buttonVStackView)
        buttonVStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-60)
        }
    }
}

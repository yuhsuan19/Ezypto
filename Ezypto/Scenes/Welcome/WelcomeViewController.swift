//
//  WelcomeViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/2/28.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class WelcomeViewController: UIViewController {

    var onRoute: ((Route) -> Void)?

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to"
        label.font = .systemFont(ofSize: 26)
        label.textColor = AppColor.mainText
        return label
    }()

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ezypto"
        label.font = .systemFont(ofSize: 48, weight: .heavy)
        label.textColor = AppColor.main
        return label
    }()

    private lazy var welcomeLabelVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, appNameLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()

    private lazy var createNewWalletButton: UIButton = {
        let button = ActionButton(style: .full, title: "Create a new wallet")
        return button
    }()

    private lazy var importWalletButton: UIButton = {
        let button = ActionButton(style: .plain, title: "Import an existing wallet")
        return button
    }()

    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createNewWalletButton, importWalletButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewBindings()
    }
}

// MARK: - Private functions
extension WelcomeViewController {
    private func setUpViews() {
        view.backgroundColor = AppColor.backgroundGrey

        view.addSubview(welcomeLabelVStackView)
        welcomeLabelVStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(160)
        }

        view.addSubview(buttonVStackView)
        buttonVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.bottom.equalToSuperview().offset(-60)
        }
    }

    private func setUpViewBindings() {
        _ = createNewWalletButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.onRoute?(.createWallet)
            })

        _ = importWalletButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.onRoute?(.importWallet)
            })
    }
}


// MARK: - Route
extension WelcomeViewController {
    enum Route {
        case createWallet
        case importWallet
    }
}

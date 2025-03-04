//
//  AccountViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountViewController: UIViewController {

    var onRoute: ((Route) -> Void)?
    var onLogout: (() -> Void)?

    private let viewModel: AccountViewModel

    private lazy var backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = AppColor.mainText
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var copyAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(.copy, for: .normal)
        button.alpha = 0.7
        return button
    }()

    private lazy var addressHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressLabel, copyAddressButton])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private lazy var removeWalletButton: UIButton = ActionButton(style: .full, title: "Remove wallet from device")

    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewBindings()
        setUpBindings()

        updateViews()
    }
    
}

// MARK: - Private functions
extension AccountViewController {
    private func setUpViews() {
        view.backgroundColor = AppColor.backgroundGrey

        title = "Account"
        navigationItem.leftBarButtonItem = backButton


        view.addSubview(removeWalletButton)
        removeWalletButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }

        copyAddressButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        view.addSubview(addressHStackView)
        addressHStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }

    private func setUpViewBindings() {
        _ = backButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.onRoute?(.back)
            })

        _ = copyAddressButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.copyAddress()
            })
        
        _ = removeWalletButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.removeWallet()
            })
    }

    private func setUpBindings() {

    }

    private func updateViews() {
        addressLabel.text = viewModel.displayedAddress()
    }
}

//MARK: - Route
extension AccountViewController {
    enum Route {
        case back
    }
}

//
//  HomeViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {

    var onRoute: ((Route) -> Void)?

    private lazy var blockchainChip: BlockchainChipView = BlockchainChipView()
    private lazy var addressChip: AddressChipView = AddressChipView()

    private lazy var nativeTokenBalanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.mainText
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var nativeTokenSymbol: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.mainText
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()

    private lazy var nativeTokenVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nativeTokenBalanceLabel, nativeTokenSymbol])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
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
    }
}

// MARK: - Private functions
extension HomeViewController {
    private func setUpViews() {
        view.backgroundColor = AppColor.backgroundGrey
        title = "Home"

        view.addSubview(blockchainChip)
        blockchainChip.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        view.addSubview(addressChip)
        addressChip.update(displayAddress: viewModel.displayedAddress())
        addressChip.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(blockchainChip.snp.bottom).offset(32)
        }

        view.addSubview(nativeTokenVStackView)
        nativeTokenVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(addressChip.snp.bottom).offset(24)
        }
    }

    private func setUpViewBindings() {
        _ = blockchainChip.tapObservable
            .take(until: rx.deallocated)
            .subscribe(onNext: { _ in
                print("todo - open blockchain picker")
            })

        _ = addressChip.tapObservable
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                onRoute?(.account)
            })
    }

    private func setUpBindings() {
        _ = viewModel.blockchainRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                blockchainChip.update(blockchain: viewModel.blockchainRelay.value)
                nativeTokenSymbol.text = viewModel.nativeTokenSymbol()
            })

        _ = viewModel.nativeBalanceRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                nativeTokenBalanceLabel.text = viewModel.nativeBalanceRelay.value
            })
    }
}

//MARK: - Route
extension HomeViewController {
    enum Route {
        case account
    }
}

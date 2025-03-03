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

        updateViews()
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
        addressChip.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(blockchainChip.snp.bottom).offset(32)
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
            .observe(on: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                self?.updateViews()
            })
    }

    private func updateViews() {
        blockchainChip.update(blockchain: viewModel.blockchainRelay.value)
        addressChip.update(displayAddress: viewModel.displayedAddress())
    }
}

//MARK: - Route
extension HomeViewController {
    enum Route {
        case account
    }
}

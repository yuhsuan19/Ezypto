//
//  HomeViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {

    private lazy var blockchainChip: BlockchainChipView = BlockchainChipView()

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
    }

    private func setUpViewBindings() {
        _ = blockchainChip.tapObservable
            .take(until: rx.deallocated)
            .subscribe(onNext: { _ in
                print("todo - open blockchain picker")
            })
    }

    private func setUpBindings() {
        _ = viewModel.blockchainRelay
            .observe(on: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] blockchain in
                self?.blockchainChip.update(blockchain: blockchain)
            })


    }
}

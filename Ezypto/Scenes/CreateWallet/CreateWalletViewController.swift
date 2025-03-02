//
//  CreateWalletViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateWalletViewController: UIViewController {

    var onRoute: ((Route) -> Void)?

    private lazy var backButton: UIButton = BackButton()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Wallet"
        label.textColor = AppColor.mainText
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Please keep your recovery phrases in a safe place. You'll be asked to re-enter the phrases (in order) to recover your wallet"
        label.numberOfLines = 0
        label.textColor = AppColor.main
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = TopLeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: PhraseCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var copyRecoveryPhrasesButton: UIButton = {
        let button = ActionButton(style: .plain, title: "Copy your recovery phrases")
        return button
    }()

    private lazy var startToUseButton: UIButton = {
        let button = ActionButton(style: .full, title: "Start to use")
        return button
    }()

    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [copyRecoveryPhrasesButton, startToUseButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private let viewModel: CreateWalletViewModel

    init(viewModel: CreateWalletViewModel) {
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
extension CreateWalletViewController {
    private func setUpViews() {
        view.backgroundColor = AppColor.backgroundGrey

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerY.equalTo(titleLabel)
        }

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        view.addSubview(buttonVStackView)
        buttonVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(descLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(buttonVStackView.snp.top).offset(-40)
        }
    }

    private func setUpViewBindings() {
        _ = backButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.onRoute?(.back)
            })

        _ = copyRecoveryPhrasesButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.copyMnemonics()
            })

        _ = startToUseButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.createWallet()
            })
    }

    private func setUpBindings() {
        _ = viewModel.recoveryPhrasesRelay
            .take(until: rx.deallocated)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension CreateWalletViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewModel.displayModel(at: indexPath.item)
        let font = PhraseCollectionViewCellUX.font
        let width = text.widthOf(font)

        return CGSize(width: width + PhraseCollectionViewCellUX.hPadding * 2, height: PhraseCollectionViewCellUX.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhraseCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.update(phrase: viewModel.displayModel(at: indexPath.item))
        return cell
    }
}

//MARK: - Route
extension CreateWalletViewController {
    enum Route {
        case back
    }
}

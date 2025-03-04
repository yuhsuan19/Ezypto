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

    private lazy var showRecoveryPhraseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show your recovery phrases", for: .normal)
        button.setTitleColor(AppColor.darkSub, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
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

        view.addSubview(addressHStackView)
        addressHStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        copyAddressButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        view.addSubview(showRecoveryPhraseButton)
        showRecoveryPhraseButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(34)
            $0.top.equalTo(addressHStackView.snp.bottom).offset(20)
        }

        view.addSubview(removeWalletButton)
        removeWalletButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(showRecoveryPhraseButton.snp.bottom).offset(16)
            $0.bottom.equalTo(removeWalletButton.snp.top).offset(-16)
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

        _ = showRecoveryPhraseButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleDisplayRecoveryPhrases()
            })

        _ = removeWalletButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.removeWallet()
            })
    }

    private func setUpBindings() {
        _ = viewModel.displayRecoverPhrasesRelay
            .take(until: rx.deallocated)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] displayed in
                self?.showRecoveryPhraseButton.setTitle(
                    displayed ? "Hide your recovery phrases" : "Show your recovery phrases",
                    for: .normal
                )
                self?.collectionView.isHidden = !displayed
            })

        _ = viewModel.walletRemovedSubject
            .take(until: rx.deallocated)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.onLogout?()
            })
    }

    private func updateViews() {
        addressLabel.text = viewModel.displayedAddress()
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension AccountViewController {
    enum Route {
        case back
    }
}

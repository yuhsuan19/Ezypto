//
//  ImportWalletViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/1.
//

import UIKit
import RxSwift
import RxCocoa

final class ImportWalletViewController: UIViewController {

    var onRoute: ((Route) -> Void)?

    private lazy var backButton: UIButton = BackButton()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Import Wallet"
        label.textColor = AppColor.mainText
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Type your 12-word recovery phrase to restore your wallet"
        label.numberOfLines = 0
        label.textColor = AppColor.main
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = AppColor.lightSub.withAlphaComponent(0.2)
        textField.textColor = AppColor.mainText
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
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

    private let viewModel: ImportWalletViewModel

    init(viewModel: ImportWalletViewModel) {
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
extension ImportWalletViewController {
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

        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(descLabel.snp.bottom).offset(12)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(textField.snp.bottom).offset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
        }
    }

    private func setUpViewBindings() {
        _ = backButton.rx.tap
            .throttle(UIConstants.buttonThrottleTime, scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.onRoute?(.back)
            })
    }

    private func setUpBindings() {
        _ = viewModel.recoveryPhrasesRelay
            .take(until: rx.deallocated)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })

        _ = viewModel.isRecoveryPhraseCompleted
            .take(until: rx.deallocated)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isCompleted in
                if isCompleted {
                    self?.textField.resignFirstResponder()
                } else {
                    self?.textField.becomeFirstResponder()
                }
            })

        _ = viewModel.clearTextFieldSubject
            .take(until: rx.deallocated)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.textField.text?.removeAll()
            })
    }
}

extension ImportWalletViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.add(phrase: textField.text)
        return true
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ImportWalletViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewModel.recoveryPhrase(at: indexPath.item)
        let font = PhraseCollectionViewCellUX.font
        let width = text.widthOf(font)

        return CGSize(width: width + PhraseCollectionViewCellUX.hPadding * 2, height: PhraseCollectionViewCellUX.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhraseCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.update(phrase: viewModel.recoveryPhrase(at: indexPath.item))
        return cell
    }
}

//MARK: - Route
extension ImportWalletViewController {
    enum Route {
        case back
    }
}

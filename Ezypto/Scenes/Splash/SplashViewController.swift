//
//  SplashViewController.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit

final class SplashViewController: UIViewController {

    private let viewModel: SplashViewModel

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ezypto"
        label.font = .systemFont(ofSize: 56, weight: .heavy)
        label.textColor = AppColor.main
        return label
    }()

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()

    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appNameLabel, indicator])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 36
        return stackView
    }()

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}

extension SplashViewController {
    private func setUpViews() {
        view.backgroundColor = AppColor.backgroundGrey
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

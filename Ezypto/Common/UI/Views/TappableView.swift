//
//  TappableView.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit
import RxCocoa
import RxSwift

class TappableView: UIView {
    var tapObservable: Observable<UITapGestureRecognizer> {
        return tapGesture.rx.event.asObservable()
    }

    private let tapGesture = UITapGestureRecognizer()

    init() {
        super.init(frame: .zero)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpViews() {
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
}

//
//  CreateWalletViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import Foundation
import RxSwift
import RxRelay

final class CreateWalletViewModel {
    let recoveryPhrasesRelay: BehaviorRelay<[String]> = .init(value: [])

    func numberOfItems() -> Int {
        return recoveryPhrasesRelay.value.count
    }

    func displayModel(at index: Int) -> String {
        return "\(index+1). \(recoveryPhrasesRelay.value[index])"
    }
}


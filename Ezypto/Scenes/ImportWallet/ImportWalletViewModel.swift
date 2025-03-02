//
//  ImportWalletViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/2.
//

import Foundation
import RxSwift
import RxRelay

final class ImportWalletViewModel {

    let recoveryPhrasesRelay: BehaviorRelay<[String]> = .init(value: [])
    let isRecoveryPhraseCompletedRelay: BehaviorRelay<Bool> = .init(value: false)
    let clearTextFieldSubject: PublishSubject<Void> = .init()

    private let disposeBag = DisposeBag()

    init() {
        setUpBindings()
    }

    func numberOfItems() -> Int {
        return recoveryPhrasesRelay.value.count
    }

    func displayModel(at index: Int) -> String {
        return "\(index+1). \(recoveryPhrasesRelay.value[index])"
    }

    func add(phrase: String?) {
        guard let phrase, !isRecoveryPhraseCompletedRelay.value else {
            return
        }

        let trimmed = phrase.lowercased().filter { $0.isLetter }
        guard !trimmed.isEmpty && !recoveryPhrasesRelay.value.contains(trimmed) else {
            return
        }

        recoveryPhrasesRelay.accept(recoveryPhrasesRelay.value + [trimmed])
        clearTextFieldSubject.onNext(())
    }
}

extension ImportWalletViewModel {

    private func setUpBindings() {
        recoveryPhrasesRelay.subscribe(onNext: { [weak self] _ in
            self?.checkRecoveryPhraseCompleted()
        })
        .disposed(by: disposeBag)
    }

    private func checkRecoveryPhraseCompleted() {
        isRecoveryPhraseCompletedRelay.accept(MnemonicsHelper.validate(phrases: recoveryPhrasesRelay.value))
    }
}

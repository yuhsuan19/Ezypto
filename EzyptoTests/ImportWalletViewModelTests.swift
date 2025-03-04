//
//  ImportWalletViewModelTests.swift
//  EzyptoTests
//
//  Created by Shane Chi on 2025/3/4.
//

import XCTest
import RxSwift
import RxCocoa
import Web3Core

@testable import Ezypto

final class ImportWalletViewModelTests: XCTestCase {
    private var viewModel: ImportWalletViewModel!
    private var mockKeychainManager: MockKeychainManager!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockKeychainManager = MockKeychainManager()
        viewModel = ImportWalletViewModel(keychainManager: mockKeychainManager)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        mockKeychainManager = nil
        disposeBag = nil
        super.tearDown()
    }

    func testAddPhrase() {
        // Given
        let phrase = "apple"

        // When
        viewModel.add(phrase: phrase)

        // Then
        XCTAssertEqual(viewModel.numberOfItems(), 1)
        XCTAssertEqual(viewModel.displayModel(at: 0), "1. apple")
    }

    func testAddDuplicatePhrase() {
        // Given
        let phrase1 = "apple"
        let phrase2 = "doctor"

        // When
        viewModel.add(phrase: phrase1)
        viewModel.add(phrase: phrase2)

        viewModel.add(phrase: phrase1)

        // Then
        XCTAssertEqual(viewModel.numberOfItems(), 2)
        XCTAssertEqual(viewModel.displayModel(at: 0), "1. apple")
        XCTAssertEqual(viewModel.displayModel(at: 1), "2. doctor")
    }

    func testAddInvalidPhrase() {
        // Given
        let invalidPhrases = ["", "12345", "  ", nil]

        // When
        invalidPhrases.forEach { viewModel.add(phrase: $0) }

        // Then
        XCTAssertEqual(viewModel.numberOfItems(), 0)
    }

    func testRemovePhrase() {
        // Given
        viewModel.add(phrase: "apple")
        viewModel.add(phrase: "doctor")

        // When
        viewModel.removePhrase(at: 0)

        // Then
        XCTAssertEqual(viewModel.displayModel(at: 0), "1. doctor")
        XCTAssertNil(viewModel.displayModel(at: 1))
    }

    func testIsRecoveryPhraseCompletedRelayShouldBeTrue() {
        // Given
        let expectation = XCTestExpectation(description: "isRecoveryPhraseCompletedRelay should be true")
        viewModel.isRecoveryPhraseCompletedRelay
            .skip(1)
            .subscribe(onNext: { isCompleted in
                if isCompleted {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // When
        let phrases = ["unhappy", "nice", "extra", "alcohol", "vehicle", "control", "unable", "inmate", "tortoise", "alpha", "lend", "estate"]
        phrases.forEach { viewModel.add(phrase: $0) }

        // Then
        wait(for: [expectation], timeout: 1)
    }

    func testIsRecoveryPhraseCompletedRelayShouldBeFalse() {
        // Given
        let expectation = XCTestExpectation(description: "isRecoveryPhraseCompletedRelay should be false")
        viewModel.isRecoveryPhraseCompletedRelay
            .skip(1)
            .subscribe(onNext: { isCompleted in
                if !isCompleted {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // When
        let phrases = ["apple", "doctor"]
        phrases.forEach { viewModel.add(phrase: $0) }


        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateWallet() {
        // Given
        let expectation = XCTestExpectation(description: "walletManager created fail")
        let phrases = ["unhappy", "nice", "extra", "alcohol", "vehicle", "control", "unable", "inmate", "tortoise", "alpha", "lend", "estate"]

        viewModel.generateWalletManagerResultSubject
            .subscribe(onNext: { result in
                switch result {
                case let .success(walletManager):
                    if walletManager.address() == EthereumAddress("0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9")! {
                        expectation.fulfill()
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        phrases.forEach { viewModel.add(phrase: $0) }

        // When
        viewModel.createWallet()

        // Then
        XCTAssertEqual(mockKeychainManager.savedMnemonic, phrases.joined(separator: " "))
        wait(for: [expectation], timeout: 1.0)
    }
}

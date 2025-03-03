//
//  AccountViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import UIKit

final class AccountViewModel {
    private let walletManager: WalletManagerProtocol

    init(walletManager: WalletManagerProtocol) {
        self.walletManager = walletManager
    }

    func displayedAddress() -> String? {
        return walletManager.addressStringValue()
    }

    func copyAddress() {
        UIPasteboard.general.string = walletManager.addressStringValue()
    }

    func removeWallet() {
    }
}

//
//  SplashViewModel.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import Foundation

final class SplashViewModel {

    private let keychainManager: KeychainManager

    init(keychainManager: KeychainManager = KeychainManager()) {
        self.keychainManager = keychainManager
    }
}

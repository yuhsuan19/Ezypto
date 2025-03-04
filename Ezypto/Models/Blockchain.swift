//
//  Blockchain.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/3.
//

import Foundation

enum Blockchain {
    case sepoliaEthereum
}

extension Blockchain {
    var isMainnet: Bool {
        switch self {
        case .sepoliaEthereum:
            return false
        }
    }

    var displayName: String {
        switch self {
        case .sepoliaEthereum:
            return BlockchainConstants.sepoliaBlockchainName
        }
    }

    var logoImageName: String {
        switch self {
        case .sepoliaEthereum:
            return BlockchainConstants.sepoliaBlockchainLogo
        }
    }

    var nativeTokenSymbol: String {
        switch self {
        case .sepoliaEthereum:
            return BlockchainConstants.sepoliaNativeTokenSymbol
        }
    }

    var nativeTokenDecimals: Int {
        switch self {
        case .sepoliaEthereum:
            return 18
        }
    }

    var rpcURL: URL {
        switch self {
        case .sepoliaEthereum:
            return BlockchainConstants.sepoliaRPCURL
        }
    }

    var chainId: Int {
        switch self {
        case .sepoliaEthereum:
            return BlockchainConstants.sepoliaChainId
        }
    }
}

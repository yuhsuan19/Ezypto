//
//  BlockchainInteractionProvider.swift
//  Ezypto
//
//  Created by Shane Chi on 2025/3/4.
//

import Foundation
import Web3Core
import web3swift
import BigInt

final class BlockchainInteractionProvider {

    private var webe3Client: Web3?

    func getNativeTokenBalance(of address: EthereumAddress) async throws {
        guard let webe3Client else {
            throw BlockchainInteractionProviderError.web3ClientNotReady
        }

        do {
            let result = try await webe3Client.eth.getBalance(for: address)
            print(result)
        } catch {
            throw BlockchainInteractionProviderError.failToGetNativeTokenBalance
        }


//        let privateKeyData = Data(hex: "YourPrivateKeyHex")
//        let keystore = try! BIP32Keystore(privateKeyData)!
//        let keystoreManager = KeystoreManager([keystore])
//        web3.addKeystoreManager(keystoreManager)
//
//        var transaction: CodableTransaction = .emptyTransaction
//        transaction.from = add
//        transaction.value = BigUInt(1000)
//        try await web3.eth.send(transaction)

    }
//    0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9

    func sendNativeToken(from: EthereumAddress, keystore: BIP32Keystore) async throws {
        guard let webe3Client else {
            throw BlockchainInteractionProviderError.web3ClientNotReady
        }

        var transaction: CodableTransaction = CodableTransaction(type: .eip1559, to: EthereumAddress("0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9")!, value: BigUInt(1093))
//        transaction.from = from
//        transaction.to = EthereumAddress("0xBAeDaE6Dd72AdDf64AfE201cE9e7a4A28F0c5ce9")!
//        transaction.value = BigUInt(1093)

        do {
            let privateKey = try keystore.UNSAFE_getPrivateKeyData(password: "", account: from)
            try transaction.sign(privateKey: privateKey, useExtraEntropy: false)
            let result = try await webe3Client.eth.send(transaction)
            print(result)
        } catch {
            throw error
        }
    }

    func setUpWeb3Client(keystore: KeystoreManager, blockchain: Blockchain) async throws {
        do {
            let web3Client = try await Web3.new(
                blockchain.rpcURL,
                network: .Custom(networkID: BigUInt(blockchain.chainId))
            )
            web3Client.provider.policies = Policies(
                gasLimitPolicy: .automatic,
                gasPricePolicy: .automatic
            )
            web3Client.addKeystoreManager(keystore)

            self.webe3Client = web3Client
        } catch {
            throw BlockchainInteractionProviderError.failToSetUpWeb3Client
        }
    }
}

// MARK: - Error
enum BlockchainInteractionProviderError: Error {
    case failToSetUpWeb3Client
    case web3ClientNotReady
    case failToGetNativeTokenBalance
}

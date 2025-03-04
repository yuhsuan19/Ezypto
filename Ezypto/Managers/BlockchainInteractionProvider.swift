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

    func getNativeTokenBalance(of address: EthereumAddress) async throws -> BigUInt {
        guard let webe3Client else {
            throw BlockchainInteractionProviderError.web3ClientNotReady
        }

        do {
            let result = try await webe3Client.eth.getBalance(for: address)
            return result
        } catch {
            throw BlockchainInteractionProviderError.failToGetNativeTokenBalance
        }
    }

    @discardableResult
    func sendNativeToken(from: EthereumAddress, to: EthereumAddress, value: BigUInt) async throws -> String {
        do {
            var tx: CodableTransaction = .emptyTransaction
            tx.from = from
            tx.to = to
            tx.value = value

            return try await sendTransaction(transaction: tx, abi: Web3.Utils.coldWalletABI)
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

// MARK: - Private functions
extension BlockchainInteractionProvider {
    private func sendTransaction(transaction: CodableTransaction, abi: String) async throws -> String {
        guard let webe3Client else {
            throw BlockchainInteractionProviderError.web3ClientNotReady
        }
        do {
            var transaction = transaction
            let contract = webe3Client.contract(Web3.Utils.coldWalletABI, at: transaction.to, abiVersion: 2)
            contract?.transaction = transaction
            guard let operation = contract?.createWriteOperation() else {
                throw BlockchainInteractionProviderError.failToPrepareOperation
            }
            transaction.gasLimit = try await webe3Client.eth.estimateGas(for: operation.transaction)
            transaction.gasPrice = try await webe3Client.eth.gasPrice()
            let policies = Policies(
                noncePolicy: .latest,
                gasLimitPolicy: .manual(transaction.gasLimit),
                gasPricePolicy: .manual(transaction.gasPrice ?? 0),
                maxFeePerGasPolicy: .automatic,
                maxPriorityFeePerGasPolicy: .automatic
            )
            return try await operation.writeToChain(password: "", policies: policies).hash

        } catch {
            throw error
        }
    }
}

// MARK: - Error
enum BlockchainInteractionProviderError: Error {
    case failToSetUpWeb3Client
    case web3ClientNotReady
    case failToGetNativeTokenBalance
    case failToPrepareOperation
}

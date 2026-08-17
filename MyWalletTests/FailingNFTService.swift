//
//  Untitled.swift
//  MyWallet
//
//  Created by John Xavier  on 17/08/2026.
//

import Foundation
@testable import MyWallet

final class FailingNFTService: NFTServiceProtocol {
    func fetchProducts() async throws -> [NFT] { throw APIError.server("Server unavailable") }
    func fetchMyNFTs() async throws -> [NFT] { throw APIError.server("Server unavailable") }
    func fetchWallet() async throws -> [Coin] { throw APIError.server("Server unavailable") }
    func buyNFT(id: String) async throws { throw APIError.server("NFT already sold") }
    func createNFT(image: Data, title: String, description: String, price: String) async throws {
        throw APIError.server("Only png and jpeg allowed")
    }
}

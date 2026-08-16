//
//  MockNFTService.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//
import Foundation

final class MockNFTService: NFTServiceProtocol {
    private func load<T: Decodable>(_ name: String, as type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw APIError.server("Missing fixture: \(name).json")
        }
        return try JSONDecoder().decode(T.self, from: Data(contentsOf: url))
    }

    func fetchProducts() async throws -> [NFT] {
        try await Task.sleep(for: .milliseconds(300))
        return try load("allNftList", as: NFTListResponse.self).items
    }

    func fetchMyNFTs() async throws -> [NFT] {
        try await Task.sleep(for: .milliseconds(300))
        return try load("myNftList", as: NFTListResponse.self).items
    }

    func fetchWallet() async throws -> [Coin] {
        try await Task.sleep(for: .milliseconds(300))
        return try load("myCoinList", as: WalletResponse.self).coins
    }

    func buyNFT(id: String) async throws {
        try await Task.sleep(for: .milliseconds(500))
    }

    func createNFT(image: Data, title: String, description: String, price: String) async throws {
        try await Task.sleep(for: .milliseconds(500))
    }
}

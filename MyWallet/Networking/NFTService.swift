//
//  NFTService.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//
import Foundation

protocol NFTServiceProtocol {
    func createNFT(image: Data, title:String, description: String, price: String) async throws
    func fetchProducts() async throws -> [NFT]
    func fetchMyNFTs() async throws -> [NFT]
    func fetchWallet() async throws -> [Coin]
    func buyNFT(id: String) async throws
}

final class NFTService: NFTServiceProtocol {
    
    private let client: APIClient
    
    init(client: APIClient = .shared){
        self.client = client
    }
    
    func createNFT(image: Data, title: String, description: String, price: String) async throws {

           _ = try await client.uploadNFT(image: image, title: title,
                                       description: description, price: price)
        
    }
    
    func fetchProducts() async throws -> [NFT] {
        try await client.request(.products, as: NFTListResponse.self).items
    }
    
    func fetchMyNFTs() async throws -> [NFT] {
        try await client.request(.myNFTs, as: NFTListResponse.self).items
    }
    
    func fetchWallet() async throws -> [Coin] {
        try await client.request(.walletBalance, as: WalletResponse.self).coins

    }
    
    func buyNFT(id: String) async throws {
        _ = try await client.request(.buyNFT(nftID: id))
    }
    
}

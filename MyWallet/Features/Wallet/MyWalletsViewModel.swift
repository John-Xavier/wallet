//
//  MyWalletsViewModel.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import Foundation
import Combine

@MainActor
final class MyWalletsViewModel: ObservableObject {
    
    enum Section: String, CaseIterable {
        case nfts = "My NFTs"
        case coins = "Coins"
    }
    
    enum State {
        case loading
        case loaded(nfts: [NFT], coins: [Coin])
        case failed(String)
    }
    
    @Published var selected: Section = .nfts
    @Published private(set) var state: State = .loading
    
    private let service: NFTServiceProtocol
    
    init(service: NFTServiceProtocol) {
        self.service = service
    }
    
    func load() async {
        state = .loading
        
        do {
            
            async let nfts = service.fetchMyNFTs().sorted {
                ($0.purchasedAt ?? .distantFuture) > ($1.purchasedAt ?? .distantFuture)
            }

            async let coins = service.fetchWallet()
            
            
            state = .loaded(nfts: try await nfts, coins: try await coins)
        } catch {
            state = .failed((error as? APIError)?.errorDescription ?? "Couldn't load your wallet.")
        }
    }
    
}

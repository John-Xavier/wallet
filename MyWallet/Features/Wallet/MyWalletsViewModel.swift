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
                ($0.createdAt ?? .distantFuture) > ($1.createdAt ?? .distantFuture)
            }

            async let coins = service.fetchWallet()
            
            let sorted = try await nfts
            print("NFT order:", sorted.prefix(5).map { "\($0.title) — \($0.createdAt?.description ?? "nil")" })
            
            state = .loaded(nfts: sorted, coins: try await coins)
        } catch {
            state = .failed((error as? APIError)?.errorDescription ?? "Couldn't load your wallet.")
        }
    }
    
}

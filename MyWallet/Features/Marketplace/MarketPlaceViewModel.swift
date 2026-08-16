//
//  MarketPlaceViewModel.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import Foundation
import Combine

@MainActor
final class MarketPlaceViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([NFT])
        case empty
        case failed(String)
    }
    
    @Published private(set) var state: State = .loading
    
    private let service: NFTServiceProtocol
    
    init(service: NFTServiceProtocol) {
        self.service = service
    }
    
    func load() async {
        state = .loading
        do{
            let items = try await service.fetchProducts().filter(\.available)
            state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            state = .failed((error as? APIError)?.errorDescription ?? "Something went wrong")
        }
    }
}

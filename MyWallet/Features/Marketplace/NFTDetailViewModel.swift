//
//  NFTDetailViewModel.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import Foundation
import Combine

struct AlertMessage: Identifiable {
    let id = UUID()
    let text: String
}

@MainActor
final class NFTDetailViewModel: ObservableObject {
    
    @Published var showConfirm = false
    @Published var isPurchasing = false
    @Published var showSuccess = false
    @Published var errorMessage: AlertMessage?
    @Published var usdtBalance: String?
    
    private let service: NFTServiceProtocol
    private let appState: AppState

    init(service: NFTServiceProtocol, appState: AppState) {
        self.service = service
        self.appState = appState
    }
    
    func buy(_ nft:NFT) async {
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            try await service.buyNFT(id: nft.id)
            appState.walletNeedsRefresh = true
            showConfirm = false
            showSuccess = true
        } catch {
            showConfirm = false
            try? await Task.sleep(for: .milliseconds(200))
            errorMessage = AlertMessage(text: (error as? APIError)?.errorDescription ?? "Purchase Failed")
        }
    }
    
    func getBalace() async{
        do {
            
            let coins = try await service.fetchWallet()
            let formattedbalance = coins.first(where: { $0.symbol == "USDT" })?.formattedBalance
            usdtBalance = formattedbalance

        } catch {
            //failed to fetch
            errorMessage = AlertMessage(text: (error as? APIError)?.errorDescription ?? "Failed to Fetch Balance")

        }
    }
}

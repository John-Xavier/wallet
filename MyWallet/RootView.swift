//
//  RootView.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    @StateObject private var router = Router()
    @StateObject private var walletRouter = Router()
    @State private var selectedTab : MainTab = .marketplace
    private let service: NFTServiceProtocol = NFTService()
    
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 16) {
                AppHeader()
                TopTabBar(selected: $selectedTab)
                
                switch selectedTab {
                case .marketplace:
                    MarketPlaceView(viewModel: MarketPlaceViewModel(service: service))
                case .wallets:
                    MyWalletsView(viewModel: MyWalletsViewModel(service: service))
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
            .background(Color.screenBG)
            .navigationBarHidden(true)
            .navigationDestination(for: Route.self) { route in
                destination(for: route)
            }
        }
        .environmentObject(router)
         
    }
    
    @ViewBuilder
    private func destination(for route:Route) -> some View {
        switch route {
        case .nftDetail(let nft):
            NFTDetailView(nft: nft, viewModel: NFTDetailViewModel(service: service, appState: appState))
        case .createNFT:
            CreateNFTView(viewModel: CreateNFTViewModel(service: service))
        }
    }
}

#Preview {
    RootView()
}

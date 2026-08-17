//
//  MyWalletsView.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct MyWalletsView: View {
    @StateObject private var viewModel: MyWalletsViewModel
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var router: Router

    init(viewModel: MyWalletsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let columns = [GridItem(.flexible(), spacing: Metrics.gridSpacing), GridItem(.flexible(), spacing: Metrics.gridSpacing)]
    
    var body: some View {
            
            VStack(spacing: 16) {

                HStack(spacing: 8){
                    SegmentedPills(selected: $viewModel.selected)
                        .padding(.horizontal, Metrics.padding)
                    
                    Spacer()
                    
                    if viewModel.selected == .nfts {
                        Button {
                            router.push(.createNFT)
                        } label: {
                            Text("Create NFT")
                                .font(.poppins(14, .medium))
                                .foregroundStyle(Color.brandBlue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(Color.white))
                                .overlay(Capsule().stroke(Color.brandBlue, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Metrics.padding)
                
                
                switch viewModel.state {
                case .loading:
                    Spacer()
                    ProgressView()
                    Spacer()
                case .loaded(let nfts, let coins):
                    if viewModel.selected == .nfts {
                        
                        if nfts.isEmpty {
                            emptyState("")
                        } else {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: Metrics.gridSpacing) {
                                    ForEach(nfts) { nft in
                                        NFTCard(nft: nft)
                                    }
                                }.padding(.horizontal, Metrics.padding)
                            }
                        }
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(coins) { CoinRow(coin: $0) }
                            }
                            .padding(.horizontal, Metrics.padding)
                        }
                    }
                case .failed(let message):
                    Spacer()
                    VStack(spacing: 12) {
                        Text(message).font(.poppins(14))
                            .foregroundStyle(Color.textSecondary)
                        Button("Retry") {Task { await viewModel.load() } }
                        
                    }
                    Spacer()
                }
            }
            .background(Color.screenBG)
            .task {
                await viewModel.load()
            }
            .onAppear {
                if appState.walletNeedsRefresh {
                    appState.walletNeedsRefresh = false
                    Task { await viewModel.load() }
                }
            }
        
    }
    
    private func emptyState(_ text: String) -> some View {
        VStack {
            Spacer()
            Text(text)
                .font(.poppins(14))
                .foregroundStyle(Color.textSecondary)
            Spacer()
        }
    }
}

#Preview {
    MyWalletsView(viewModel: MyWalletsViewModel(service: MockNFTService()))
}

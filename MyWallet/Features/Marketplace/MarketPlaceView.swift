//
//  MarketPlaceView.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct MarketPlaceView: View {
    @StateObject private var viewModel: MarketPlaceViewModel
    @EnvironmentObject private var router: Router
    
    init(viewModel:MarketPlaceViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let columns = [GridItem(.flexible(), spacing: Metrics.gridSpacing), GridItem(.flexible(), spacing: Metrics.gridSpacing)]
    
    var body: some View {

        Group {
            switch viewModel.state {
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .loaded(let items):
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Metrics.gridSpacing) {
                        ForEach(items) { nft in
                            NFTCard(nft: nft)
                                .onTapGesture {
                                    router.push(.nftDetail(nft))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .refreshable { await viewModel.load() }
            case .empty:
                EmptyStateView(icon: "square.grid.2x2",
                                  title: "No NFTs available")
            case .failed(let message):
                EmptyStateView(icon: "exclamationmark.triangle",
                               title: "Couldn't load",
                               message: message,
                               retry: { Task { await viewModel.load() } })
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    MarketPlaceView(viewModel: MarketPlaceViewModel(service: MockNFTService()))
}

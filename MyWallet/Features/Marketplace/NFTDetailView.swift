//
//  NFTDetailView.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import SwiftUI

struct NFTDetailView: View {
    
    @EnvironmentObject private var appState: AppState

    
    let nft: NFT
    @StateObject private var viewModel: NFTDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(nft:NFT, viewModel: NFTDetailViewModel) {
        self.nft = nft
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: nft.imageURL) { phase in
                        switch phase {
                        case .success(let image):
                             
                            image.resizable().aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "photo")
                                                .font(.title2)
                                                .foregroundStyle(Color.textSecondary)
                        case .empty:
                             ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: Metrics.imageRadius))
                    
                    Text(nft.title)
                        .font(.nftTitle)
                        .foregroundStyle(Color.textPrimary)
                    
                    Label(nft.owner ?? "Unknown", systemImage: "person")
                        .font(.poppins(16))
                        .foregroundStyle(Color.textSecondary)
                    
                    Divider()
                    
                    Text("Description")
                        .font(.poppins(16, .medium))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text(nft.description.isEmpty ? "No description provided." : nft.description)
                        .font(.poppins(16))
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(8)
                }
                .padding(.horizontal, Metrics.heroPadding)
            }
            
            HStack {
                VStack(alignment: .leading,spacing: 4) {
                    Text("Price")
                        .font(.poppins(14))
                        .foregroundStyle(Color.textSecondary)
                    Text(nft.formattedPrice)
                        .font(.priceValue)
                        .foregroundStyle(Color.textPrimary)
                    
                }
                Spacer()
                BrandButton(
                    title: nft.available ? "Buy NFT" : "Sold Out",
                    isEnabled: nft.available
                ) {
                    viewModel.showConfirm = true
                }.frame(width: 180)
            }
            .padding(Metrics.heroPadding)
            .background(.white)
            
        }
        .background(Color.screenBG)
        .navigationTitle("NFT Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showConfirm) {
            //confirm purchase sheet
            ConfirmPurchaseSheet(nft: nft, viewModel: viewModel).presentationDetents([.height(480)])
        }
        .sheet(isPresented: $viewModel.showSuccess) {
            PurchaseSuccessView {
                viewModel.showSuccess = false
                dismiss()
            }
            .presentationDetents([.height(280)])
        }

        
    }
}

#Preview {
    NFTDetailView(nft: .sample, viewModel: NFTDetailViewModel(service: MockNFTService(), appState: AppState()))
}

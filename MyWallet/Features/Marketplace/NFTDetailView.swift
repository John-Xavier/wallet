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
                    Color.clear
                        .frame(height: 365)
                        .overlay {
                            AsyncImage(url: nft.imageURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.textSecondary)
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(nft.title)
                        .font(.nftTitle)
                        .foregroundStyle(Color.textPrimary)
                    
                    Label(nft.owner ?? "Unknown", systemImage: "person")
                        .font(.poppins(16))
                        .foregroundStyle(Color.textSecondary)
                    
                    DashedLine()
                    
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
        .alert(item: $viewModel.errorMessage) { message in
            Alert(title: Text("Purchase Failed"),
                    message: Text(message.text),
                    dismissButton: .default(Text("OK")))
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: nft.imageURL ?? URL(string: "https://techbank.com")!) {
                    Image("share")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.textPrimary)
                }
            }
        }
       

        
    }
}

#Preview {
    NFTDetailView(nft: .sample, viewModel: NFTDetailViewModel(service: MockNFTService(), appState: AppState()))
}

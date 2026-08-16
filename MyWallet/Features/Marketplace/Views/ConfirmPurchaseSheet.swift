//
//  ConfirmPurchaseSheet.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import SwiftUI

struct ConfirmPurchaseSheet: View {
    let nft: NFT
    @ObservedObject var viewModel: NFTDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack{
                Text("Confirm Your Purchase")
                    .font(.poppins(18, .medium))
                    .foregroundStyle(Color.textPrimary)
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.textPrimary)
                    }
                }
               
            }.padding(20)
            
            Divider()
            
            HStack(spacing: 12) {
                AsyncImage(url: nft.imageURL) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.15)
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(nft.title)
                        .font(.poppins(18, .medium))
                    Text(nft.owner.map { String($0.prefix(8)) } ?? "Unknown")
                        .font(.poppins(14))
                        .foregroundStyle(Color.textSecondary)
                        
                }
                Spacer()
            }
            .padding(20)
                        
            DashedLine()

            stackedRow("Buying Price", nft.formattedPrice)

            DashedLine()

            stackedRow("Wallet Balance", viewModel.usdtBalance ?? "0.00")

            DashedLine()
            
            HStack{
                
                Spacer()
                
                BrandButton(title: "Buy NFT", isLoading: viewModel.isPurchasing) {
                    Task { await viewModel.buy(nft)}
                }
                .frame(width: 180)
                .padding(.vertical, 24)
                
                Spacer()
                
            }
           
        }.padding(Metrics.heroPadding)
            .onAppear{
                Task{
                    await viewModel.getBalace()
                }
            }
    }
    
    private func priceRow(_ label: String, _ value:String, emphasized: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.poppins(14))
                .foregroundStyle(Color.textSecondary)
            Spacer()
            Text(value)
                .font(emphasized ? .priceValue : .poppins(14, .medium))
                .foregroundStyle(Color.textPrimary)
        }
    }
    
    private func stackedRow(_ label: String,_ value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
                Text(label).font(.poppins(14)).foregroundStyle(Color.textSecondary)
                Text(value).font(.spaceGrotesk(20)).foregroundStyle(Color.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    ConfirmPurchaseSheet(nft: .sample, viewModel: NFTDetailViewModel(service: MockNFTService(), appState: AppState()))
}

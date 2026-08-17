//
//  NFTCard.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct NFTCard: View {
    
    let nft: NFT
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    AsyncImage(url: nft.imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
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
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Metrics.imageRadius))

            Text(nft.title)
                .font(.poppins(14, .medium))
                .lineLimit(1)
                .foregroundStyle(Color.textPrimary)
            
            Text(nft.formattedPrice)
                .font(.poppins(14, .semibold))
                .foregroundStyle(Color.brandBlue)
        }
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    
    HStack {
        NFTCard(nft: .sample)
        NFTCard(nft: .sample)
    }
    .padding()
    .background(Color.screenBG)
}

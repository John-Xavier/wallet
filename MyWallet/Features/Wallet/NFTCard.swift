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
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: Metrics.imageRadius))
            
            Text(nft.title)
                .font(.poppins(14, .medium))
                .foregroundStyle(Color.textPrimary)
            
            Text(nft.formattedPrice)
                .font(.spaceGrotesk(14))
                .foregroundStyle(Color.brandBlue)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading
        )
        .background(Color.white, in: RoundedRectangle(cornerRadius: Metrics.cardRadius))
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

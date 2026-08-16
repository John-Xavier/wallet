//
//  PurchaseSuccessView.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct NFTCreatedSuccessView: View {
    
    let onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 56, height: 56)
                .foregroundStyle(Color.brandGreen)
            
            Text("NFT Created Successfully!")
                .font(.poppins(18, .medium))
                .foregroundStyle(Color.textPrimary)
            
            Text("Your NFT is now visible in My NFTs Tab")
                .font(.poppins(14))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
            
            BrandButton(title: "View NFT", action: onDone)
                .frame(width: 160)
            
        }
        .padding(Metrics.heroPadding)
    }
}

#Preview {
    PurchaseSuccessView { }
}

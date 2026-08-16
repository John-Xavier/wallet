//
//  PurchaseSuccessView.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct PurchaseSuccessView: View {
    
    let onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 56, height: 56)
                .foregroundStyle(Color.brandGreen)
            
            Text("Purchase Successful")
                .font(.poppins(18, .medium))
                .foregroundStyle(Color.textPrimary)
            
            Text("Your NFT has been added to My NFTs.")
                .font(.poppins(14))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
            
            BrandButton(title: "Close", action: onDone)
                .frame(width: 160)
            
        }
        .padding(Metrics.heroPadding)
    }
}

#Preview {
    PurchaseSuccessView { }
}

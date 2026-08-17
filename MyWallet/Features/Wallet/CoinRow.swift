//
//  CoinRow.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct CoinRow: View {
    let coin: Coin
    
    var body: some View {
        HStack(spacing: 12) {
            
            Group {
                if UIImage(named: coin.symbol.lowercased()) != nil {
                    Image(coin.symbol.lowercased())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Circle()
                        .fill(Color.brandBlue.opacity(0.15))
                        .overlay(
                            Text(String(coin.symbol.prefix(1)))
                                .font(.poppins(16, .semibold))
                                .foregroundStyle(Color.brandBlue)
                        )
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            Text(coin.symbol)
                .font(.poppins(16, .medium))
                .foregroundStyle(Color.textPrimary)
            
            Spacer()
            
            HStack{
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(coin.formattedBalance) \(coin.symbol)")
                        .font(.poppins(15, .medium))
                        .foregroundStyle(Color.textPrimary)
                    Text("$\(coin.formattedBalance)")
                        .font(.poppins(12))
                        .foregroundStyle(Color.textSecondary)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(Color.brandBlue)
            }
           
        }
        .padding(12)
        .background(Color(hex: 0xEBF2FE), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    CoinRow(coin: Coin.sample)
}

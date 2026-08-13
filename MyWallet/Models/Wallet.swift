//
//  Wallet.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import Foundation

struct WalletResponse: Decodable {
    let coins: [Coin]
}

struct Coin: Decodable, Identifiable {
    var id: String { symbol }
    let symbol: String
    let balance: Double
    
    var formattedBalance: String {
            String(format: "%.4f", balance)
        }
}

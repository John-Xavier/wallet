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
        balance == balance.rounded()
            ? String(format: "%.0f", balance)
            : String(format: "%.4f", balance)
        }
}

#if DEBUG
extension Coin {
    static let sample = Coin(symbol: "USDT", balance: 0.6980000000000091)

    static let samples = [
        Coin(symbol: "BNB", balance: 223),
        Coin(symbol: "ETH", balance: 256),
        Coin(symbol: "BTC", balance: 22),
        Coin(symbol: "USDT", balance: 0.6980000000000091)
    ]
}
#endif

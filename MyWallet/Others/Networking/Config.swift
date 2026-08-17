//
//  Config.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//
import Foundation

nonisolated enum Config{
    static let baseURL = URL(string: "https://nodeapi.techbank.live/interview")!
    static let apiKey = "user-key"
    static let userID = "user-001"
    static let email = "jane.cooper@example.com"
}

nonisolated enum MockData {
    static func data(for endpoint: Endpoint) -> Data? {
        let name: String
        switch endpoint {
        case .products: name = "allNftList"
        case .myNFTs: name = "myNftList"
        case .walletBalance: name = "myCoinList"
        case .buyNFT:  return Data(#"{"success":true}"#.utf8)
        }
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
        
    }
}

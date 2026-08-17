//
//  NFT.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//
import Foundation

struct NFTListResponse: Decodable {
    let items: [NFT]
}

struct NFT: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let price: Double
    let currency: String
    let owner: String?
    let imageUrl: String
    let available: Bool
    let purchasedAt: Date?
    let createdAt: Date?
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 4
        return (formatter.string(from: price as NSNumber) ?? "\(price)") + " " + currency
    }
    
    var imageURL: URL? {
          URL(string: imageUrl.addingPercentEncoding(
              withAllowedCharacters: .urlQueryAllowed) ?? imageUrl)
      }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, price, currency, owner, imageUrl, available, purchasedAt,createdAt
    }
}

#if DEBUG
extension NFT {
    static let sample = NFT(
        id: "691461156dc97f9ce2987299",
        title: "Hypebest Apes B",
        description: "Unique masterpiece",
        price: 4.75,
        currency: "USDT",
        owner: "691461156dc97f9ce2987297",
        imageUrl: "https://nodeapi.techbank.live/interview/uploads/seed/Robo.jpg",
        available: true,
        purchasedAt: nil, createdAt: nil
    )
}
#endif

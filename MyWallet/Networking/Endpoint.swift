//
//  Endpoint.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import Foundation

nonisolated enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

nonisolated enum Endpoint {
    case products
    case myNFTs
    case walletBalance
    case buyNFT(nftID: String)
    
    var path: String {
        switch self {
        case .products: return "/v2/beetobeeGetProducts"
        case .myNFTs: return "/v2/beetobeeMyNfts"
        case .walletBalance: return "/v2/beetobeeMywalletBalance"
        case .buyNFT: return "/v2/beetobeeBuyNft"

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .buyNFT: return .post
        default: return .get
        
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .myNFTs, .walletBalance:
            return [
                URLQueryItem(name: "userid", value: Config.userID),
                URLQueryItem(name: "email", value:  Config.email)
            ]
        default:
            return nil
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .buyNFT(let nftID):
            return ["email": Config.email, "userid": Config.userID, "nftid": nftID]
        default:
            return nil
        }
    }
}

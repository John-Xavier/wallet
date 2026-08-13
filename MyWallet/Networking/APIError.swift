    //
//  APIError.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import Foundation

nonisolated enum APIError : LocalizedError {
    case server(String)
    case decoding(Error)
    case network(Error)
    case invalidResponse
    
    var errorDescription: String?{
        switch self {
        case .server(let message): return message
        case .decoding: return "Couldnt read the server response."
        case .network: return "Network unavailable. Check your connection."
        case .invalidResponse: return "Something went wrong. Please try again"
        }
    }
}

nonisolated struct ServerErrorResponse: Decodable {
    let error : String
    let details: [String]?
}

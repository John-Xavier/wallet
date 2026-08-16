//
//  APIClient.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import Foundation

protocol NFTServiceProtocol {
    func createNFT(image: Data, title:String, description: String, price: String) async throws
    func fetchProducts() async throws -> [NFT]
    func fetchMyNFTs() async throws -> [NFT]
    func fetchWallet() async throws -> [Coin]
    func buyNFT(id: String) async throws
}

enum Route: Hashable {
    case nftDetail(NFT)
    case createNFT
}

actor APIClient {
    static let shared = APIClient()
    private let session: URLSession = .shared
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
       d.dateDecodingStrategy = .iso8601
       return d
   }()

    
    func request<T: Decodable>(_ endpoint:Endpoint, as type: T.Type) async throws -> T {
        let data = try await perform(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
    
    
    @discardableResult
    func request(_ endpoint: Endpoint) async throws -> Data {
        try await perform(endpoint)
    }
    
    private func perform(_ endpoint:Endpoint) async throws -> Data {
        
        if Config.useMockData, let mock = MockData.data(for: endpoint) {
            try await Task.sleep(for: .milliseconds(400))
            return mock
        }
        
        var components = URLComponents(url: Config.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)!
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else { throw APIError.invalidResponse}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        request.setValue(Config.apiKey, forHTTPHeaderField: "x-api-key")
        
        if let body = endpoint.body {
            request.httpMethod = endpoint.method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.network(error)
        }
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("STATUS:", http.statusCode)
        print("BODY:", String(data: data, encoding: .utf8)?.prefix(300) ?? "nil")
        
        if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
            throw APIError.server(serverError.error)
        }
        
        guard (200...299).contains(http.statusCode) else {
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw APIError.server(serverError.details?.first ?? serverError.error)
            }
            throw APIError.invalidResponse
        }
        
        return data
                
    }
    
    func uploadNFT(image: Data, title:String, description: String, price: String) async throws -> Data {
        let boundary = "Boundary-\(UUID().uuidString)"
        let url = Config.baseURL.appendingPathComponent("/v2/beetobeeNftUpload")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(Config.apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        let fields = [
            "title" : title,
            "description" : description,
            "selling_price" : price,
            "userid" : Config.userID,
            "email": Config.email
        ]
        
        for (key, value) in fields {
              body.append("--\(boundary)\r\n")
              body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
              body.append("\(value)\r\n")
          }
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"Nft_image\"; filename=\"nft.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(image)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.network(error)
        }
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
            throw APIError.server(serverError.error)
        }
        
        guard (200...299).contains(http.statusCode) else {
            if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw APIError.server(serverError.details?.first ?? serverError.error)
            }
            throw APIError.invalidResponse
        }
        return data
        
    }
}

nonisolated private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) { append(data) }
    }
}

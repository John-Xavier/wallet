//
//  APIClient.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import Foundation

actor APIClient {
    static let shared = APIClient()
    private let session: URLSession = .shared
    
    func request<T: Decodable>(_ endpoint:Endpoint, as type: T.Type) async throws -> T {
        let data = try await perform(endpoint)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
    
    
    @discardableResult
    func request(_ endpoint: Endpoint) async throws -> Data {
        try await perform(endpoint)
    }
    
    private func perform(_ endpoint:Endpoint) async throws -> Data {
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

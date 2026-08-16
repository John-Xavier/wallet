//
//  CreateNFTViewModel.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import Foundation
import Combine
import UIKit

@MainActor
final class CreateNFTViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var price = ""
    @Published var image : UIImage?
    
    @Published var isUploading = false
    @Published var showSuccess = false
    @Published var errorMessage : String?
    
    private let service: NFTServiceProtocol
    
    init(service: NFTServiceProtocol) {
        self.service = service
    }
    
    var canSubmit: Bool {
        image != nil
        && !title.trimmingCharacters(in: .whitespaces).isEmpty
        && Double(price) != nil
        && Double(price)! > 0
    }
    
    func submit() async {
        guard let image, let data = image.jpegData(compressionQuality: 0.7) else {
            errorMessage = "Please select an image"
            return
        }
        
        isUploading = true
        defer { isUploading = false }
        
        do {
            try await service.createNFT(
                image: data,
                title: title.trimmingCharacters(in: .whitespaces),
                description: description,
                price: price
            )
            
            showSuccess = true
            
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Upload failed"
        }
        
    }
}

//
//  CreateNFTView.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct CreateNFTView: View {
    
    @StateObject private var viewModel: CreateNFTViewModel
    @State private var showPicker = false
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: CreateNFTViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Button { showPicker = true } label: {
                    ZStack {
                        if let image = viewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            
                            VStack(spacing: 8) {
                                Image("upload")
                                    .font(.title2)
                                Text("Upload NFT")
                                    .font(.poppins(14))
                                    .foregroundStyle(Color.textPrimary)
                                Text("( Type :  png, jpeg )")
                                    .font(.poppins(12))
                            }
                            .foregroundStyle(Color.textSecondary)
                        }
                    }
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .background(Color(hex: 0xDDDDDD))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.textSecondary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [6]))
                    )
                }
                .buttonStyle(.plain)
                
                field("Title", placeholder: "Enter the NFT name", text: $viewModel.title, required: true)
                field("Description", placeholder: "Enter", text: $viewModel.description, multiline: true)
                field("Selling Price", placeholder: "Enter the amount", text: $viewModel.price, required: true, suffix: "USDT", keyboard: .decimalPad)
                
                BrandButton(title: "Create NFT", isLoading: viewModel.isUploading, isEnabled: viewModel.canSubmit) {
                    Task { await viewModel.submit() }
                    
                }
                .padding(.top, 8)
            }
            .padding(Metrics.padding)
        }
        .background(Color.screenBG)
        .navigationTitle("Create NFT")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $viewModel.image)
        }
        .sheet(isPresented: $viewModel.showSuccess) {
            NFTCreatedSuccessView {
                dismiss()
            }
            .presentationDetents([.height(280)])
        }
        .alert(item: $viewModel.errorMessage) { message in
            Alert(title: Text("Upload Failed"),
                    message: Text(message.text),
                    dismissButton: .default(Text("OK")))
        }
    }
    
    //text field template
    private func field(_ label: String, placeholder: String, text: Binding<String>, required: Bool = false, suffix: String? = nil, multiline: Bool = false, keyboard: UIKeyboardType = .default) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                Text(label)
                if required { Text("*").foregroundStyle(.red) }
            }
            .font(.poppins(14, .medium))
            .foregroundStyle(Color.textPrimary)
            
            HStack {
                TextField(placeholder, text: text, axis: multiline ? .vertical : .horizontal)
                    .lineLimit(multiline ? 4...4 : 1...1)
                    .keyboardType(keyboard)
                    .font(.poppins(14))
                
                if let suffix {
                    Text(suffix)
                        .font(.poppins(14))
                        .foregroundStyle(Color.textPrimary)
                }
            }
            .padding(14)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.textSecondary.opacity(0.3), lineWidth: 1)
            }
            
          
        }
        
    }
}

#Preview {
    CreateNFTView(viewModel: CreateNFTViewModel(service: MockNFTService()))
}

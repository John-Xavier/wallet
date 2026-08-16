//
//  BrandButton.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import SwiftUI

struct BrandButton: View {
    
    let title: String
    var isLoading = false
    var isEnabled = true
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            ZStack {
                HStack(spacing: 12) {
                    Text(title)
                    Image(systemName: "arrow.right")
                }
                .font(.poppins(18, .medium))
                .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                    
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(LinearGradient.brandButton)
            .clipShape(Capsule())
            .opacity(isEnabled ? 1 : 0.5)
        }
        .disabled(!isEnabled || isLoading)
    }
}

#Preview {
    BrandButton(title: "Press", action: { })
}

//
//  EmptyStateView.swift
//  MyWallet
//
//  Created by John Xavier  on 16/08/2026.
//

import SwiftUI

struct EmptyStateView: View {
    
    let icon: String
    let title: String
    var message: String?
    var retry: (() -> Void)?
    
    var body: some View {
          

                VStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundStyle(Color.textSecondary)

                    Text(title)
                        .font(.poppins(16, .medium))
                        .foregroundStyle(Color.textPrimary)

                    if let message {
                        Text(message)
                            .font(.poppins(14))
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    if let retry {
                        Button("Retry", action: retry)
                            .font(.poppins(14, .medium))
                            .foregroundStyle(Color.brandBlue)
                            .padding(.top, 4)
                    }
                }
                .padding(32)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        
    }
}

#Preview {
    EmptyStateView(icon: "exclamationmark.triangle", title: "Couldn't Load")
}

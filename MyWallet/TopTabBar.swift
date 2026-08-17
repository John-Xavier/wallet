//
//  TopTabBar.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

enum MainTab: String, CaseIterable {
    case marketplace = "Marketplace"
    case wallets = "My Wallets"
}

struct TopTabBar: View {
    @Binding var selected: MainTab
    
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selected = tab
                    }
                } label: {
                    VStack(spacing: 10) {
                        Text(tab.rawValue)
                            .font(.poppins(16, selected == tab ? .medium : .regular))
                            .foregroundStyle(Color.textPrimary)
                        
                        Rectangle()
                            .fill(selected == tab ? Color.brandBlue : .clear)
                            .frame(height: 3)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .background(alignment: .bottom, content: {
            Rectangle()
                .fill(Color.textSecondary.opacity(0.2))
                .frame(height: 1)
        })
    }
}

#Preview {
    TopTabBar(selected: .constant(.marketplace))
}

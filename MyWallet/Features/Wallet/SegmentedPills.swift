//
//  SegmentedPills.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct SegmentedPills: View {
    @Binding var selected: MyWalletsViewModel.Section
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MyWalletsViewModel.Section.allCases, id: \.self) { section in
                
                Text(section.rawValue)
                    .font(.poppins(14, .medium))
                    .foregroundStyle(selected == section ? .white : Color.textSecondary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background{
                        if selected == section {
                            Capsule().fill(Color.brandBlue)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selected = section
                        }
                    }
            }
        }
        .background(Capsule().fill(Color(hex: 0xEFEFEF)))
    }
}

#Preview {
    SegmentedPills(selected: .constant(.nfts))
}

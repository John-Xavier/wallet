//
//  AppHeader.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//

import SwiftUI

struct AppHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TECHBANK")
                .font(.poppins(20, .semibold))
                .overlay(
                    LinearGradient(
                        colors: [Color(hex: 0x4A5AFC), Color(hex: 0x9E41FE)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    Text("TECHBANK")
                        .font(.poppins(20, .semibold))
                )
            
            VStack(alignment: .leading, spacing: 12) {
                Circle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "person.fill")
                    .foregroundStyle(Color.textSecondary)
                )

                    Text("Jane Cooper").font(.poppins(24, .medium))
                }
                .padding(20)
                .frame(maxWidth: .infinity, minHeight: 155, alignment: .leading)
                .background(Image("header-bg").resizable())
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, Metrics.padding)
        .padding(.top, Metrics.topCardPadding)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
    }
}

#Preview {
    AppHeader()
}

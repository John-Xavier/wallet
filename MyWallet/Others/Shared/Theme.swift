//
//  Theme.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//
import Foundation
import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >>  8) & 0xFF) / 255,
            blue:  Double( hex        & 0xFF) / 255,
            opacity: 1
        )
    }

    static let brandBlue      = Color(hex: 0x3389FB)
    static let brandGreen     = Color(hex: 0x34C759)
    static let screenBG       = Color(hex: 0xFAFAFA)
    static let textPrimary    = Color(hex: 0x0C0A19)
    static let textSecondary  = Color(hex: 0x979796)
}

extension LinearGradient {
    static let brandButton = LinearGradient(
        colors: [Color(hex: 0x3A6CF4), Color(hex: 0x0EC3F4)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

enum Metrics {
    static let cardRadius: CGFloat  = 10
    static let imageRadius: CGFloat = 4
    static let buttonRadius: CGFloat = 68
    static let gridSpacing: CGFloat  = 16
    static let padding: CGFloat      = 16
    static let topCardPadding: CGFloat = 20
    static let heroPadding: CGFloat  = 24
}

extension Font {
    static func poppins(_ size: CGFloat, _ weight: Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .bold:     name = "Poppins-Bold"
        case .medium:   name = "Poppins-Medium"
        case .semibold: name = "Poppins-SemiBold"
        default:        name = "Poppins-Regular"
        }
        return .custom(name, size: size)
    }

    static func spaceGrotesk(_ size: CGFloat) -> Font {
        .custom("SpaceGrotesk-Bold", size: size)
    }

    static let nftTitle   = poppins(20, .medium)
    static let priceValue = spaceGrotesk(20)
}

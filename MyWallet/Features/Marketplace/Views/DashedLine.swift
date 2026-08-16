//
//  DashedLine.swift
//  MyWallet
//
//  Created by John Xavier  on 16/08/2026.
//

import SwiftUI

struct DashedLine: View {
    var body: some View {
            Line()
                   .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                   .foregroundStyle(Color.textSecondary.opacity(0.4))
                   .frame(height: 1)
                   .padding(.horizontal, 20)
    }
}
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: rect.width, y: 0))
        return p
    }
}
#Preview {
    DashedLine()
}

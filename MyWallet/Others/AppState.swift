//
//  AppState.swift
//  MyWallet
//
//  Created by John Xavier  on 14/08/2026.
//
import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var walletNeedsRefresh = false
}

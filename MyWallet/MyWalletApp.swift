//
//  MyWalletApp.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import SwiftUI

@main
struct MyWalletApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var router = Router()
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(router)
                .preferredColorScheme(.light)
            
        }
    }
}

//
//  ContentView.swift
//  MyWallet
//
//  Created by John Xavier  on 13/08/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var log = "Tap Run"
    
    var body: some View {
        VStack {
            Button("Run") {
                Task {
                    await runAll()
                }
            }
            .buttonStyle(.borderedProminent)
            
            ScrollView {
                Text(log)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
        }
        .padding()
    }
    
    private func runAll() async {
        log = "Running...\n"
        
        async let products = fetchProducts()
        async let mine = fetchMyNFTs()
        async let wallet = fetchWallet()
        
        log += await products + "\n"
        log += await mine + "\n"
        log += await wallet
    }
    
    private func fetchProducts() async -> String {
        do {
            let res = try await APIClient.shared.request(.products, as: NFTListResponse.self)
            let available = res.items.filter(\.available)
            let affordable = available.filter{ $0.price <= 0.698 }
            return """
            PRODUCTS: \(res.items.count) total, \(available.count) available
            Affordable (<=0.698): \(affordable.map { "\($0.title) @\($0.price)" }.joined(separator: ", "))
            First: \(res.items.first?.title ?? "-") | \(res.items.first?.id ?? "-")
            Bad URLs: \(res.items.filter { $0.imageURL == nil }.count)
            """
            
        } catch {
            return "PRODUCTS FAILED: \(error)"
        }
    }
    private func fetchMyNFTs() async -> String {
        do {
            let res = try await APIClient.shared.request(.myNFTs, as: NFTListResponse.self)
            return "MY NFTS: \(res.items.count) items | first: \(res.items.first?.title ?? "-")"

        } catch {
            return "MY NFTS FAILED: \(error)"
        }
    }
    
    private func fetchWallet() async -> String {
            do {
                let res = try await APIClient.shared.request(.walletBalance, as: WalletResponse.self)
                return "WALLET: " + res.coins.map { "\($0.symbol) \($0.balance)" }.joined(separator: " | ")
            } catch {
                return "WALLET FAILED: \(error)"
            }
        }
}

#Preview {
    ContentView()
}

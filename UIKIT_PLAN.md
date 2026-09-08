# MyWallet — UIKit (MVVM) Port Plan

Goal: rebuild the existing SwiftUI app in **UIKit** using **MVVM** + a **lightweight
coordinator** for navigation. Keep it simple and readable — no over-engineering.

SwiftUI version is already complete and stays untouched as the visual reference.

---

## 1. Architecture at a glance

```
Model  ──►  ViewModel  ──►  ViewController  ──►  Views/Cells
(data +      (state +        (owns view +          (dumb UI)
 network)     logic)          binds to VM)

Coordinator ── owns navigation, creates VC+VM, handles routing
```

- **MVVM**: each screen = a `ViewModel` (logic/state, no UIKit imports) + a `ViewController` (UI only).
- **Coordinator**: satisfies "clean, scalable navigation, no hardcoded view routing."
  VCs never `push`/`present` another screen directly — they call their coordinator.
- **POP**: services and coordinators sit behind protocols (already true for the service).
- **Binding**: VM → VC via a simple closure (`onStateChange`). No Combine, no third-party.

---

## 2. Target layout

Fresh **UIKit Xcode project** (`MyWalletUIKit`). Keep the SwiftUI project as-is for reference.
Drag the reusable files in (see §3). If the spec instead wants one project, add a second
UIKit target — but a standalone project is simpler to build and submit.

Suggested folders:

```
MyWalletUIKit/
├── App/                 SceneDelegate, AppDelegate, AppCoordinator
├── Models/              NFT.swift, Wallet.swift              (reused)
├── Networking/          APIClient, Endpoint, APIError, ...   (reused)
├── Services/            NFTService (+ protocol), Mock        (reused)
├── Shared/              Theme+UIKit, UIImageCompression, image loader
├── Features/
│   ├── Marketplace/     VM, VC, Cell
│   ├── NFTDetail/       VM, VC (+ confirm/success)
│   ├── MyWallets/       VM, VC, NFTCell, CoinCell
│   └── CreateNFT/       VM, VC
└── Resources/           Assets.xcassets, Fonts, JSON, Info.plist
```

---

## 3. Reused unchanged (drag in, zero edits)

No SwiftUI import — pure logic:

- `Models/NFT.swift`, `Models/Wallet.swift`
- `Networking/` — `APIClient`, `Endpoint`, `APIError`, `Config`, `MockNFTService`
- `Services/NFTService.swift` + `NFTServiceProtocol` (async/await, already POP ✔)
- `Shared/UIImageCompression.swift`
- `Resources/` — JSON, fonts, `Assets.xcassets`

The whole networking + service layer *is* your Model layer. It works identically in UIKit.

---

## 4. Small rewrites

**Theme** — port `Theme.swift` to UIKit:
- `UIColor(hex:)` with the same 5 colors (brandBlue, brandGreen, screenBG, textPrimary, textSecondary).
- `UIFont.poppins(_:_:)` and `.spaceGrotesk(_:)` helpers.
- `Metrics` enum copies over unchanged.
- Register fonts in `Info.plist` (Fonts provided by application).

**ViewModels** — keep the exact logic from the SwiftUI VMs; only change observation:
- Drop `ObservableObject`; keep `@MainActor` and the `async` methods verbatim.
- Replace `@Published var state` with:
  ```swift
  private(set) var state: State = .loading { didSet { onStateChange?(state) } }
  var onStateChange: ((State) -> Void)?
  ```
- VC assigns `onStateChange` in `viewDidLoad` and calls `render(state)`.
- The `State` enums (`loading/loaded/empty/failed`) transfer as-is.

**Image loading** — SwiftUI `AsyncImage` is gone. Add a small `UIImageView` extension:
`URLSession` fetch + `NSCache`, and cancel the in-flight task in `prepareForReuse`.

---

## 5. Navigation — lightweight coordinator

One protocol + an app coordinator + per-tab flow. VCs hold a `weak` coordinator ref and
call intent methods instead of routing themselves.

```swift
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
```

- `AppCoordinator` builds a `UITabBarController` with two `UINavigationController`s.
- `MarketplaceCoordinator.start()` creates `MarketplaceVC` + its VM, injects the service.
- Routing intents (no hardcoded pushes in VCs):
  - `showDetail(for: NFT)` → push `NFTDetailVC`
  - `showConfirmPurchase(for: NFT)` → present sheet (`UISheetPresentationController`)
  - `showPurchaseSuccess()` / `showCreateSuccess()` → present/push
  - `showCreateNFT()` → push form
- Service is created once and injected down through the coordinators (dependency injection).

This is the minimum that satisfies "scalable navigation, no hardcoded routing" without
ceremony. Don't add child-coordinator factories or a DI container — too much for this scope.

---

## 6. Screen-by-screen

| Feature | ViewModel (reuse logic) | ViewController | Views / cells |
|---|---|---|---|
| **Marketplace** | `MarketplaceViewModel` — `load()`, filters `available` | `MarketplaceVC` | `UICollectionView` compositional grid + `NFTCardCell` |
| **NFT Detail + Buy** | `NFTDetailViewModel` — `buy()`, updates AppState | `NFTDetailVC` | scroll layout; confirm = sheet; success = modal |
| **My Wallets** | `MyWalletsViewModel` — `load()` (async-let nfts+coins), `selected` section | `MyWalletsVC` | `UISegmentedControl` + collection/table; `NFTCell`, `CoinCell` |
| **Create NFT** | `CreateNFTViewModel` — `canSubmit`, `submit()` (already imports UIKit) | `CreateNFTVC` | form + `PHPickerViewController` + existing compression |

Shared UI: reusable loading spinner, empty-state view, error alert (`UIAlertController`).

**AppState** (`walletNeedsRefresh`) → plain shared class injected via coordinator.
Wallet VC re-loads in `viewWillAppear` when the flag is set (after a buy or create).

---

## 7. Error handling (spec requirement)

- Service already throws typed `APIError`.
- Each VM maps errors to `.failed(message)` (already does).
- VC renders `.failed` as an inline error/empty view + optional retry; use `UIAlertController`
  for one-off action failures (buy/create), mirroring the SwiftUI `AlertMessage` behavior.

---

## 8. Build order (demoable happy-path first)

1. Project + reused files + Theme port + font registration.
2. `AppCoordinator` + tab bar + two nav controllers (empty VCs).
3. **Marketplace** list (collection + cell + image loader).
4. **NFT Detail → Confirm → Success** (the purchase flow — core of the test).
5. **My Wallets** (segmented: My NFTs + Crypto Wallet) with refresh-after-buy.
6. **Create NFT** (picker + compression + submit).
7. Loading / empty / error states, polish against Figma.

---

## 9. Submission checklist (from the brief)

- [ ] MVVM with clear separation (Model / VM / VC / Views).
- [ ] Coordinator navigation — no hardcoded routing in VCs.
- [ ] Protocol-oriented: service + coordinator behind protocols.
- [ ] Error handling on every network call.
- [ ] Clean Swift style; no dead code; readable names.
- [ ] Screens match the Figma.
- [ ] Postman collection imported / API base URL correct.
- [ ] README: architecture summary + how to run.

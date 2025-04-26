//
//  Shortcuts.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/11/24.
//

import AppIntents

struct Shortcut1: AppIntent {
    static var title: LocalizedStringResource = "Intent1 Title"
    static var description = IntentDescription("Intent1 description")
    
    static var openAppWhenRun: Bool = false
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
    
    func perform() async throws -> some ReturnsValue<Int> & ProvidesDialog {
        print("worked1")
        return .result(value: 1 , dialog: IntentDialog("shortcut dialog"))
    }
}

struct Shortcut2: AppIntent {
    static let title: LocalizedStringResource = "Intent2 Title"
    
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult {
        print("worked2")
        return .result()
    }
}

struct Shortcut3: AppIntent {
    static let title: LocalizedStringResource = "Intent3 Title"
    
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult {
        print("worked3")
        return .result()
    }
}

struct Shortcut4: AppIntent {
    static let title: LocalizedStringResource = "Intent4 Title"
    
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult {
        print("worked4")
        return .result()
    }
}

struct OpenTabIntent: AppIntent {
    static let title: LocalizedStringResource = "Open Tab"
    static var openAppWhenRun = true
    
    @Parameter(title: "Tab")
    var tab: Tab?
    
    @MainActor
    func perform() async throws -> some ProvidesDialog {
        let tabToOpen: Tab
        if let tab = tab {
            tabToOpen = tab
        } else {
            tabToOpen = try await $tab.requestDisambiguation(
                among: MockData.mockTab,
                dialog: "What Tab would you like to see?"
            )
        }
        
        if tabToOpen.name == "Home" {
            AppetizerTabsViewModel.shared.selectedTab = 0
        } else if tabToOpen.name == "Account" {
            AppetizerTabsViewModel.shared.selectedTab = 1
        } else if tabToOpen.name == "Order" {
            AppetizerTabsViewModel.shared.selectedTab = 2
        }
        
        return .result(dialog: "Okay, opening \(tabToOpen.name) tab.")
    }
}

struct PlaceOrderIntent: AppIntent {
    static let title: LocalizedStringResource = "Place Order"
    
    func perform() async throws -> some ReturnsValue<Int> & ProvidesDialog & ShowsSnippetView {
        let order = DummyOrderViewModel.shared.orderToBePlaced
        
        try await requestConfirmation(
            result: .result(
                value: 1,
                dialog: "Are you ready to order?",
                view: OrderPreviewView(order: order.dummyOrder)
            ),
            confirmationActionName: .order
        )
        
        try await DummyOrderViewModel.shared.placeOrder(order: order.dummyOrder)
        return .result(
            value: 1,
            dialog: "Order placed successfully.",
            view: OrderConfirmationView(order: order.dummyOrder)
        )
    }
}

// Provides Shortcuts to system
struct DemoAppShortcutsProvider: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .red
    
    // max number of shortcuts can be 10
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: Shortcut1(),
                phrases: [
                    "\(.applicationName) shortcut" // must have app name in phrases
                ],
                shortTitle: "Shortcut Title",
                systemImageName: "shoe"
            ),
//            AppShortcut(
//                intent: Shortcut2(),
//                phrases: [
//                    "\(.applicationName) shortcut2"
//                ],
//                shortTitle: "Shortcut2 Title",
//                systemImageName: "shoe.fill"
//            ),
//            AppShortcut(
//                intent: Shortcut4(),
//                phrases: [
//                    "\(.applicationName) shortcut4"
//                ],
//                shortTitle: "Shortcut4 Title",
//                systemImageName: "eraser"
//            ),
//            AppShortcut(
//                intent: Shortcut3(),
//                phrases: [
//                    "\(.applicationName) shortcut3"
//                ],
//                shortTitle: "Shortcut3 Title",
//                systemImageName: "pencil"
//            ),
            AppShortcut(
              intent: OpenTabIntent(),
              phrases: ["Open \(.applicationName) Tab",
            "Open \(\.$tab) on \(.applicationName)"],
              shortTitle: "Open Tab",
              systemImageName: "eraser.fill"
            ),
            AppShortcut(
              intent: PlaceOrderIntent(),
              phrases: ["Place \(.applicationName) order"],
              shortTitle: "Place Order",
              systemImageName: "eraser"
            )
        ]
    }
}

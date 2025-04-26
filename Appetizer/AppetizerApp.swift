//
//  AppetizerApp.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 10/07/24.
//

import SwiftUI

@main
struct AppetizerApp: App {
    var order = Order()
    var body: some Scene {
        WindowGroup {
            AppetizerTabView(viewModel: AppetizerTabsViewModel.shared).environmentObject(self.order)
        }
    }
}

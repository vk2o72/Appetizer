//
//  ContentView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 10/07/24.
//

import SwiftUI

final class AppetizerTabsViewModel: ObservableObject {
    static var shared = AppetizerTabsViewModel()
    let mockData = MockData.mockTab
    
    @Published var selectedTab = 0
    
    private init() {
        
    }
}

struct AppetizerTabView: View {
    @EnvironmentObject var order: Order
    @StateObject var viewModel: AppetizerTabsViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            AppetizerListView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)
            AccountView()
                .tabItem { Label("Account", systemImage: "person") }
                .tag(1)
            OrderView()
                .tabItem { Label("Order", systemImage: "bag") }
                .badge(self.order.items.count)
                .tag(2)
        }
        .tint(.cyan)
    }
}

#Preview {
    AppetizerTabView(viewModel: AppetizerTabsViewModel.shared).environmentObject(Order())
}

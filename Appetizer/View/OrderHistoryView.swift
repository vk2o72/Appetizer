//
//  OrderHistoryView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/05/25.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject var viewModel: OrderHistoryViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List(self.viewModel.cellViewModels) { cellViewModel in
                        OrderHistoryCell(viewModel: cellViewModel)
                    }
                    .listStyle(.plain)
                }
                .task(priority: .high, {
                    await self.viewModel.getData()
                })
                if self.viewModel.isLoading {
                    LoadingView()
                        .frame(width: 300, height: 200)
                } else if(self.viewModel.cellViewModels.isEmpty) {
                    EmptyStateView(image: Image(.emptyOrder), message: "Please place your first order!")
                }
            }
            .navigationTitle("📋 Order History")
        }
    }
}

#Preview {
    OrderHistoryView(viewModel: OrderHistoryViewModel())
}

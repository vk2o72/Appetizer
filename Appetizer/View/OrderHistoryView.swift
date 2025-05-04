//
//  OrderHistoryView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/05/25.
//

import SwiftUI

final class OrderHistoryViewModel: ObservableObject {
    @Published var cellViewModels: [OrderHistoryCellViewModel] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading: Bool = false
    @MainActor // will run the code in this func on main thread
    func getData() async {
        self.isLoading = true
        do {
            self.isLoading = false
            let orders: [OrderHistory] = [
                OrderHistory(amount: "12", orderID: "1233", orderDate: "Date1"),
                OrderHistory(amount: "25", orderID: "1234", orderDate: "Date2"),
                OrderHistory(amount: "18", orderID: "1235", orderDate: "Date3"),
                OrderHistory(amount: "30", orderID: "1236", orderDate: "Date4"),
                OrderHistory(amount: "22", orderID: "1237", orderDate: "Date5"),
              ]


            self.createCellViewModels(orders: orders)
        } catch {
            self.isLoading = false
            self.handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        if let appError = error as? AppError {
            switch appError {
            case .invalidURL:
                self.alertItem = AlertContext.invalidURL
            case .invalidResponse:
                self.alertItem = AlertContext.invalidResponse
            case .invalidData:
                self.alertItem = AlertContext.invalidData
            case .unableToComplete:
                self.alertItem = AlertContext.unableToComplete
            }
        } else {
            self.alertItem = AlertContext.unableToComplete
        }
    }
    
    private func createCellViewModels(orders: [OrderHistory]) {
        var cellViewModels: [OrderHistoryCellViewModel] = []
        for orders in orders {
            cellViewModels.append(OrderHistoryCellViewModel(data: orders))
        }
        
        self.cellViewModels = cellViewModels
    }
}

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

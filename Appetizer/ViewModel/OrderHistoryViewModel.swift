//
//  OrderHistoryViewModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/05/25.
//

import Foundation

final class OrderHistoryViewModel: ObservableObject {
    @Published var cellViewModels: [OrderHistoryCellViewModel] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading: Bool = false
    
    @MainActor // will run the code in this func on main thread
    func getOrderHistory() async {
        self.isLoading = true
        do {
            self.isLoading = false
            let orders: [OrderHistory]? = try await NetworkManager.shared.getOrderHistory()
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
    
    private func createCellViewModels(orders: [OrderHistory]?) {
        guard let orders = orders else { return }
        var cellViewModels: [OrderHistoryCellViewModel] = []
        for orders in orders {
            cellViewModels.append(OrderHistoryCellViewModel(data: orders))
        }
        
        self.cellViewModels = cellViewModels
    }
}

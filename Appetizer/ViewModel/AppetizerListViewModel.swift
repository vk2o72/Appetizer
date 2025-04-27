//
//  AppetizerListViewModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/08/24.
//

import SwiftUI

final class AppetizerListViewModel: ObservableObject {
    @Published var cellViewModels: [ListCellViewModel] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading: Bool = false
    @Published var isShowingDetail: Bool = false
    @Published var selectedAppetizer: Appetizer?
    
    @MainActor // will run the code in this func on main thread
    func getData() async {
        self.isLoading = true
        do {
            self.isLoading = false
            let appetizer = try await NetworkManager.shared.getData()
            self.createCellViewModels(appetizers: appetizer)
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
    
    private func createCellViewModels(appetizers: [Appetizer]) {
        var cellViewModels: [ListCellViewModel] = []
        for appetizer in appetizers {
            cellViewModels.append(ListCellViewModel(data: appetizer))
        }
        
        self.cellViewModels = cellViewModels
        
        if self.cellViewModels.isEmpty {
            self.alertItem = AlertContext.noData
        } else {
            self.alertItem = nil
        }
    }
}

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
    
    func getData() {
        self.isLoading = true
        NetworkManager.shared.getData(completed: { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let appetizer):
                    self.createCellViewModels(appetizers: appetizer)
                case .failure(let error):
                    switch error {
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }
            }
        })
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

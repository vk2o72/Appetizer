//
//  OrderHistoryCellViewModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/05/25.
//

import Foundation

final class OrderHistoryCellViewModel: Identifiable {
    private(set) var orderData: OrderHistory
    
    init(data: OrderHistory) {
        self.orderData = data
    }
}

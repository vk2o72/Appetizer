//
//  OrderHistoryCell.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/05/25.
//

import SwiftUI

struct OrderHistory: Decodable {
    let amount: String
    let orderID: String
    let orderDate: String
}

final class OrderHistoryCellViewModel: Identifiable {
    private(set) var orderData: OrderHistory
    
    init(data: OrderHistory) {
        self.orderData = data
    }
}

struct OrderHistoryCell: View {
    var viewModel: OrderHistoryCellViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, content: {
                Text("Order ID: \(self.viewModel.orderData.orderID)")
                    .font(.title2)
                    .fontWeight(.medium)
                Text("Date: \(self.viewModel.orderData.orderDate)")
                    .font(.subheadline)
            })
            .padding(.leading, 20)
            Spacer()
            Text("Amount: \(self.viewModel.orderData.amount)")
                .font(.subheadline)
                .padding(.trailing, 20)
        }
    }
}

#Preview {
    OrderHistoryCell(viewModel: OrderHistoryCellViewModel(data: OrderHistory(amount: "$4.5", orderID: "ID", orderDate: "Date")))
}

//
//  OrderView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 15/07/24.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order: Order
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List{
                        ForEach(self.order.items) { item in
                            ListCell(viewModel: ListCellViewModel(data: item))
                        }
                        .onDelete(perform: self.order.deleteItem) // IndexSet is automatically passed to the function you provide to the perform: argument of the onDelete modifier.
                    }
                    .listStyle(.plain)
                    Button(action: {}, label: {
                        ApButton(title: "$\(self.order.totalPrice, specifier: "%.2f") - Place Order")
                    })
                }
                
                if(self.order.items.isEmpty) {
                    EmptyStateView(image: Image(.emptyOrder), message: "You have no items in your order. \n Please add an appetizer")
                }
            }
            .navigationTitle("📋 Order")
        }
    }
}

#Preview {
    OrderView().environmentObject(Order())
}

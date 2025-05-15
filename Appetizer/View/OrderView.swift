//
//  OrderView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 15/07/24.
//

import SwiftUI

final class OrderViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    
    func placeOrder(order: Order) async throws {
        do {
            try await NetworkManager.shared.placeOrder(order: order)
            await MainActor.run {
                self.alertItem = AlertContext.orderPlaced
                order.items.removeAll()
            }
        } catch {
            await MainActor.run {
                self.alertItem = AlertContext.orderNotPlaced
            }
        }
    }
}

struct OrderView: View {
    @EnvironmentObject var order: Order
    @StateObject var viewModel: OrderViewModel
    
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
                    Button(action: {
                        Task {
                            do {
                                try await self.viewModel.placeOrder(order: self.order)
                            } catch {
                                print("Order not placed")
                            }
                        }
                    }, label: {
                        ApButton(title: "$\(self.order.totalPrice, specifier: "%.2f") - Place Order")
                    })
                }
                
                if(self.order.items.isEmpty) {
                    EmptyStateView(image: Image(.emptyOrder), message: "You have no items in your order. \n Please add an appetizer")
                }
            }
            .navigationTitle("📋 Order")
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            })
        }
    }
}

#Preview {
    OrderView(viewModel: OrderViewModel()).environmentObject(Order())
}

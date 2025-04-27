//
//  DummyOrder.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/11/24.
//

import SwiftUI
import AppIntents

final class DummyOrder {
    var dummyOrder: Order {
        let order = Order()
        order.addItem(MockData.sampleAppetizer)
        return order
    }
}

struct OrderPreviewView: View {
    var order: Order
    @State var isLoading: Bool = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Subtotal: 123")
                Text("Tax: 00")
                Divider()
                Text("Total: 123")
                Spacer()
                Text("Estimated delivery: 50min")
            }
            .task {
//                await self.getData()
            }
            .scenePadding()
            
            if self.isLoading {
                LoadingView()
                    .frame(width: 50, height: 50)
            }
        }
        
    }
    
    @MainActor
    private func getData() async {
        self.isLoading = true
        do {
            self.isLoading = false
            let appetizer = try await NetworkManager.shared.getData()
            print("success")
        } catch {
            self.isLoading = false
            print("Error: \(error)")
        }
    }
}

struct OrderConfirmationView: View {
    var order: Order
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("1 items purchased.")
            Spacer()
            Text("Total: 123")
            Spacer()
            Text("Estimated delivery: 50 min")
            Divider()
            Text("Thank you for your order!")
        }
        .scenePadding()
    }
}

final class DummyOrderViewModel: ObservableObject {
    static var shared = DummyOrderViewModel()
    
    private init() {
        
    }
    
    var orderToBePlaced = DummyOrder()
    
    func placeOrder(order: Order) async throws {
        print("Order placed")
    }
}

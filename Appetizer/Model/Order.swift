//
//  Order.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 06/08/24.
//

import SwiftUI

final class Order: ObservableObject {
    @Published var items: [Appetizer] = []
    
    var totalPrice: Double {
        self.items.reduce(0) {$0 + $1.price}
    }
    
    func addItem(_ appetizer: Appetizer) {
        self.items.append(appetizer)
    }
    
    func deleteItem(at offset: IndexSet) {
        self.items.remove(atOffsets: offset)
    }
}

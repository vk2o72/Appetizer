//
//  AppetizerModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 15/07/24.
//

import Foundation

struct Appetizer: Decodable, Identifiable {
    let description: String
    let imageURL: String
    let name: String
    let price: Double
    let protein: Int
    let id: Int
    let calories: Int
    let carbs: Int
}

struct AppetizerResponse: Decodable {
    let request: [Appetizer]
    
    enum CodingKeys: CodingKey {
        case request
    }
}

struct MockData {
    static let sampleAppetizer: Appetizer = Appetizer(description: "description of the dish. description of the dish. description",
                                             imageURL: "Sample",
                                             name: "test",
                                             price: 9.99,
                                             protein: 9,
                                             id: 009,
                                             calories: 9,
                                             carbs: 99)
    
    static let mockData = [sampleAppetizer, sampleAppetizer, sampleAppetizer, sampleAppetizer, sampleAppetizer, sampleAppetizer]
    
    static let mockTab = [Tab(id: UUID(), name: "Home"), Tab(id: UUID(), name: "Account"), Tab(id: UUID(), name: "Order")]
}

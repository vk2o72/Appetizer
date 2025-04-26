//
//  ListCellViewModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/08/24.
//

import SwiftUI

final class ListCellViewModel: Identifiable {
    private(set) var data: Appetizer
    
    init(data: Appetizer) {
        self.data = data
    }
}

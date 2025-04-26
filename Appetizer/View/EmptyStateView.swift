//
//  EmptyStateView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/08/24.
//

import SwiftUI

struct EmptyStateView: View {
    let image: Image
    let message: String
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(edges: .all)
            
            VStack {
                self.image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                
                Text(self.message )
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
                    .padding()
            }
        }
    }
}

#Preview {
    EmptyStateView(image: Image(.emptyOrder), message: "No order")
}

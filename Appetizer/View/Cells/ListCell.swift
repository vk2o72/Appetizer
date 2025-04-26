//
//  ListCell.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 18/07/24.
//

import SwiftUI

struct ListCell: View {
    var viewModel: ListCellViewModel
    
    var body: some View {
        HStack {
            AppetizerRemoteImage(urlString: self.viewModel.data.imageURL)
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 90)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            VStack(alignment: .leading, content: {
                Text(self.viewModel.data.name)
                    .font(.title2)
                    .fontWeight(.medium)
                Text("$\(self.viewModel.data.price, specifier: "%.2f")")
                    .font(.subheadline)
            })
        }
    }
}

#Preview {
    return ListCell(viewModel: ListCellViewModel(data: MockData.sampleAppetizer))
}

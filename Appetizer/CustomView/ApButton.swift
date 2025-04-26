//
//  ApButton.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 11/08/24.
//

import SwiftUI

struct ApButton: View {
    var title: LocalizedStringKey
    var body: some View {
        Text(self.title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .foregroundStyle(.white)
            .background(.green)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
    }
}

#Preview {
    ApButton(title: "Text")
}

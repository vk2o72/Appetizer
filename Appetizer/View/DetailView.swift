//
//  DetailView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/08/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var order: Order
    @Binding var isShowingDetailView: Bool
    let appetizer: Appetizer
    var body: some View {
        VStack {
            AppetizerRemoteImage(urlString: self.appetizer.imageURL)
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 225)
            
            VStack {
                Text(self.appetizer.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(self.appetizer.description)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
                HStack(alignment: .center, spacing: 40) {
                    VStack {
                        Text("Calories")
                            .bold()
                            .font(.caption)
                        Text(String(self.appetizer.calories))
                            .foregroundStyle(.secondary)
                            .fontWeight(.semibold)
                            .italic()
                    }
                    VStack {
                        Text("Carbs")
                            .bold()
                            .font(.caption)
                        Text(String("\(self.appetizer.carbs) g"))
                            .foregroundStyle(.secondary)
                            .fontWeight(.semibold)
                            .italic()
                    }
                    VStack {
                        Text("Protein")
                            .bold()
                            .font(.caption)
                        Text(String("\(self.appetizer.protein) g"))
                            .foregroundStyle(.secondary)
                            .fontWeight(.semibold)
                            .italic()
                    }
                }
            }
            .contentMargins(10)
            
            Spacer()
            
            Button(action: {
                self.order.addItem(self.appetizer)
                self.isShowingDetailView = false
            }, label: {
                ApButton(title: "$\(self.appetizer.price, specifier: "%.2f") - Add To Order")
            })
        }
        .padding(.bottom, 10)
        .frame(width: 300, height: 525)
        .shadow(radius: 40)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 12, height: 12)))
        .overlay(
            Button(action: {
                self.isShowingDetailView = false
            }, label: {
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.white)
                        .opacity(0.6)
                        .shadow(radius: 10)
                    Image(systemName: "xmark")
                        .imageScale(.small)
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.black)
                }
            }),
            alignment: .topTrailing)
    }
}

#Preview {
    @State var isShowingDetailView = true
    return DetailView(isShowingDetailView: $isShowingDetailView, appetizer: MockData.sampleAppetizer)
}

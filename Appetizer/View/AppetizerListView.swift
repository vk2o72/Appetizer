//
//  AppetizerListView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 15/07/24.
//

import SwiftUI

struct AppetizerListView: View {
    @StateObject private var viewModel = AppetizerListViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                List(self.viewModel.cellViewModels) { cellViewModel in
                    ListCell(viewModel: cellViewModel)
                        .onTapGesture {
                            self.viewModel.selectedAppetizer = cellViewModel.data
                            self.viewModel.isShowingDetail = true
                        }
                }
                .listStyle(.plain)
                .navigationTitle("🥗 Appetizer")
            }
            .task(priority: .high, {
                await self.viewModel.getData()
            })
            .blur(radius: self.viewModel.isShowingDetail ? 20 : 0)
            .disabled(self.viewModel.isShowingDetail)
            
            if self.viewModel.isShowingDetail {
                DetailView(isShowingDetailView: $viewModel.isShowingDetail,
                           appetizer: self.viewModel.selectedAppetizer ??
                           MockData.sampleAppetizer)
            }
            
            if self.viewModel.isLoading {
                LoadingView()
                    .frame(width: 300, height: 200)
            }
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}

#Preview {
    AppetizerListView()
}

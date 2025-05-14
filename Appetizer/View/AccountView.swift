//
//  AccountView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 15/07/24.
//

import SwiftUI

struct AccountView: View {
    @FocusState private var focusedTextField: FormTextField?
    @StateObject private var viewModel = AccountViewModel()
    
    enum FormTextField {
        case firstName, lastName, email
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section("Personal Info") {
                        TextField("First Name", text: $viewModel.firstName)
                            .focused($focusedTextField, equals: .firstName)
                            .onSubmit { self.focusedTextField = .lastName }
                            .submitLabel(.next)
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .focused($focusedTextField, equals: .lastName)
                            .onSubmit { self.focusedTextField = .email }
                            .submitLabel(.next)
                        
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .focused($focusedTextField, equals: .email)
                            .onSubmit { self.focusedTextField = nil }
                            .submitLabel(.continue)
                        
                        Button("Save changes", action: {
                            Task {
                                await self.viewModel.saveChanges()
                            }
                        })
                    }
                    Section("Request") {
                        Toggle("Extra Nampkins", isOn: $viewModel.extraNapkin)
                        Toggle("frequent Refills", isOn: $viewModel.frequentRefill)
                    }
                    Section("History") {
                        NavigationLink("Order History", destination: {
                            let viewModel: OrderHistoryViewModel = OrderHistoryViewModel()
                            OrderHistoryView(viewModel: viewModel)
                        })
                    }
                }
                .navigationTitle("🙎‍♂️ AccountView")
            }
            .task(priority: .high, {
                await self.viewModel.getUserData()
            })
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            })
            
            if self.viewModel.isLoading {
                LoadingView()
                    .frame(width: 300, height: 200)
            }
        }
    }
}

#Preview {
    AccountView()
}

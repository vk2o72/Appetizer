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
        NavigationStack {
            Form {
                Section("Personal Info") {
                    TextField("First Name", text: $viewModel.userModel.firstName)
                        .focused($focusedTextField, equals: .firstName)
                        .onSubmit { self.focusedTextField = .lastName }
                        .submitLabel(.next)
                    
                    TextField("Last Name", text: $viewModel.userModel.lastName)
                        .focused($focusedTextField, equals: .lastName)
                        .onSubmit { self.focusedTextField = .email }
                        .submitLabel(.next)
                    
                    TextField("Email", text: $viewModel.userModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .focused($focusedTextField, equals: .email)
                        .onSubmit { self.focusedTextField = nil }
                        .submitLabel(.continue)
                    
                    DatePicker("Birthday", selection: $viewModel.userModel.birthDate, displayedComponents: .date)
                    
                    Button("Save changes", action: {
                        self.viewModel.saveChanges()
                    })
                }
                Section("Request") {
                    Toggle("Extra Nampkins", isOn: $viewModel.userModel.extranampkins)
                    Toggle("frequent Refills", isOn: $viewModel.userModel.frequentRefills)
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
        .onAppear(perform: {
            self.viewModel.retrieveUserData()
        })
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}

#Preview {
    AccountView()
}

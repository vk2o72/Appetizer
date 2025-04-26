//
//  AccountViewModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/08/24.
//

import SwiftUI

final class AccountViewModel: ObservableObject {
    @AppStorage("user") private var userData: Data?
    @Published var userModel = UserModel()
    @Published var alertItem: AlertItem?
    
    var isValidForm: Bool {
        guard !self.userModel.firstName.isEmpty && !self.userModel.lastName.isEmpty && !self.userModel.email.isEmpty else {
            self.alertItem = AlertContext.invalidForm
            return false
        }
        
        guard self.userModel.email.isValidEmail else {
            self.alertItem = AlertContext.invalidEmail
            return false
        }
        
        return true
    }
    
    func saveChanges() {
        guard self.isValidForm else {
            return
        }
        
        do {
            let data = try JSONEncoder().encode(self.userModel)
            self.userData = data
            self.alertItem = AlertContext.userSaveSuccess
        } catch {
            self.alertItem = AlertContext.invalidUserData
        }
    }
    
    func retrieveUserData() {
        guard let userData = self.userData else { return }
        do {
            self.userModel = try JSONDecoder().decode(UserModel.self, from: userData)
        } catch {
            self.alertItem = AlertContext.invalidUserData
        }
    }
}

extension String {
    var isValidEmail: Bool {
        let emailFormat         = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate      = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}

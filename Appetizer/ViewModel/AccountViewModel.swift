//
//  AccountViewModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/08/24.
//

import SwiftUI

final class AccountViewModel: ObservableObject {
    @Published var userModel: UserModel?
    @Published var alertItem: AlertItem?
    @Published var isLoading: Bool = false
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var extraNapkin: Bool = false
    @Published var frequentRefill: Bool = false
    
    @MainActor // will run the code in this func on main thread
    func getUserData() async {
        self.isLoading = true
        do {
            self.isLoading = false
            self.userModel = try await NetworkManager.shared.getUserData()
            self.firstName = self.userModel?.firstName ?? ""
            self.lastName = self.userModel?.lastName ?? ""
            self.email = self.userModel?.email ?? ""
            self.extraNapkin = self.userModel?.extraNapkin ?? false
            self.frequentRefill = self.userModel?.frequentRefills ?? false
        } catch {
            self.isLoading = false
        }
    }
    
    var isValidForm: Bool {
        guard let firstName = self.userModel?.firstName,
              let lastName = self.userModel?.lastName,
              let email = self.userModel?.email,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty else {
            self.alertItem = AlertContext.invalidForm
            return false
        }
        
        guard let email = self.userModel?.email, email.isValidEmail else {
            self.alertItem = AlertContext.invalidEmail
            return false
        }
        return true
    }
    
    @MainActor
    func saveChanges() async {
        guard self.isValidForm else {
            return
        }
        
        do {
            self.isLoading = false
            let newUserData = UserModel(firstName: self.firstName,
                                        lastName: self.lastName,
                                        email: self.email,
                                        extraNapkin: self.extraNapkin,
                                        frequentRefills: self.frequentRefill)
            
            try await NetworkManager.shared.saveUserData(user: newUserData)
        } catch {
            self.isLoading = false
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

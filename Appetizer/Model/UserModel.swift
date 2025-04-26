//
//  UserModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/08/24.
//

import Foundation

struct UserModel: Codable {
    var firstName = ""
    var lastName = ""
    var email = ""
    var birthDate = Date()
    var extranampkins = false
    var frequentRefills = false
}

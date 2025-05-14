//
//  UserModel.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 05/08/24.
//

import Foundation

struct UserModel: Codable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var birthDate: Date?
    var extraNapkin: Bool?
    var frequentRefills: Bool?
}

//
//  ClientModel.swift
//  EatMe
//
//  Created by akburak zekeriya on 21/01/2025.
//

import Foundation


struct UserProfile: Codable {
    let idClient: Int
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let dateOfBirth: String
}


//
//  ClientModel.swift
//  EatMe
//
//  Created by akburak zekeriya on 21/01/2025.
//

import Foundation


struct Client: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var dateOfBirth: Date = Date()
}

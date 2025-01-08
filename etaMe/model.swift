//
//  model.swift
//  tesy
//
//  Created by akburak zekeriya on 11/12/2024.
//

import Foundation

struct Dish: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let calories: Int
    let proteins: Double
    let carbs: Double
    let URLimage: String
}


struct Order: Identifiable, Codable {
    let id: Int?
    let clientId: Int
    var items: [OrderItem]
    var total: Double {
        items.reduce(0) { $0 + ($1.pricePerDish * Double($1.quantity)) }
    }
}

struct OrderItem: Identifiable, Codable {
    let id: UUID = UUID()
    let dish_id: Int
    var quantity: Int
    let pricePerDish: Double
}


struct Client: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var dateOfBirth: Date = Date()
    var extraNapkins: Bool = false
    var frequentRefill: Bool = false
}
import Foundation

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

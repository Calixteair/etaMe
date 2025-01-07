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

struct OrderItem: Identifiable, Codable {
    var id = UUID()
    let dish_id: Int
    let quantity: Int
    
    private enum CodingKeys: String, CodingKey {
            case dish_id, quantity // Exclure `id` de la sérialisation
        }
}

struct Order: Codable {
    var items: [OrderItem]
    var dishPrices: [Int: Double] // Ajout d'un dictionnaire pour mapper dish_id aux prix

    var total: Double {
        items.reduce(0) { total, item in
            total + (Double(item.quantity) * (dishPrices[item.dish_id] ?? 0))
        }
    }
}


struct Client: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var dateOfBirth: Date = Date()
    var extraNapkins: Bool = false
    var frequentRefill: Bool = false
}

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
struct DishOrder: Identifiable, Codable {
    let idDish: Int
      let name: String
      let description: String
      let price: Double
      let calories: Int
      let proteins: Int
      let carbs: Int
      let imageURL: String
      var quantity: Int
      
      var id: Int { idDish }
}




// MARK: - Order Model
struct Order: Identifiable, Codable {
    let id: Int
    let totalPrice: Double
    let quantity: Int
    let status: String
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

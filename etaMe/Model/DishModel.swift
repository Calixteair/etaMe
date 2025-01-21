//
//  DishModel.swift
//  EatMe
//
//  Created by akburak zekeriya on 21/01/2025.
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


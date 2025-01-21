import Foundation

struct Order: Identifiable, Codable {
    let id: Int
    let totalPrice: Double
    let quantity: Int
    let status: String
    let dateOrder: String
}



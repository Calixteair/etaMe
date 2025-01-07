//
//  OrderView.swift
//  tesy
//
//  Created by akburak zekeriya on 11/12/2024.
//

import SwiftUI

struct OrderView: View {
    let clientId: Int
    @State private var order: Order = Order(items: [], dishPrices: [:])

    var body: some View {
        VStack {
            List(order.items) { item in
                HStack {
                    Text("Dish ID: \(item.dish_id)")
                    Spacer()
                    Text("Quantity: \(item.quantity)")
                }
            }
            Spacer()
            HStack {
                Text("Total: $\(order.total, specifier: "%.2f")")
                Button("Place Order") {
                    placeOrder()
                }
            }
            .padding()
        }
    }

    func placeOrder() {
        guard let url = URL(string: "http://\( ServerConfig.serverIP):\(ServerConfig.port)/order") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let orderData: [String: Any] = [
            "client_id": clientId,
            "total_price": order.total,
            "items": order.items.map { [
                "dish_id": $0.dish_id,
                "quantity": $0.quantity
            ]}
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: orderData)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error placing order: \(error)")
                }
            }.resume()
        } catch {
            print("Error encoding order: \(error)")
        }
    }
}

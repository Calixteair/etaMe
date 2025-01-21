//
//  OrderRowView.swift
//  EatMe
//
//  Created by akburak zekeriya on 21/01/2025.
//

import SwiftUI


struct OrderRow: View {
    let order: Order
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        NavigationLink(
            destination:OrderDetailView(
                        orderDetailviewModel: OrderDetailViewModel(),
                        appViewModel :appViewModel,
                        orderId: order.id,
                        orderValided: order.status == "validée"
                    
        ))
 {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Order: \(order.dateOrder)")
                        .font(.headline)
                    Text("Quantity: \(order.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("Status:")
                            .font(.subheadline)
                        Text(order.status)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(statusColor(for: order.status))
                            .padding(4)
                            .background(statusColor(for: order.status).opacity(0.2))
                            .cornerRadius(5)
                    }
                }
                Spacer()
                VStack {
                    Text(String(format: "$%.2f", order.totalPrice))
                        .font(.headline)
                        
                }
            }
            .padding(.vertical, 8)
        }
    }

    func statusColor(for status: String) -> Color {
        switch status {
        case "validée":
            return .green
        case "en cours":
            return .orange
        default:
            return .gray
        }
    }
}



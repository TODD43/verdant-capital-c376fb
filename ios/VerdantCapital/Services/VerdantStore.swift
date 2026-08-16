import Foundation
import Observation
import SwiftData

@Observable
final class VerdantStore {
    var cart: [CartLine] = []
    var paymentMethod: PaymentMethod = .mpesa
    var isSignedIn = false
    var chatEntries: [ChatEntry] = [
        ChatEntry(author: .assistant, text: "Hello — I’m the Verdant guide. I can help with produce, deliveries, or our agricultural ecosystem."),
        ChatEntry(author: .assistant, text: "This is a local scripted demo. No AI service is connected.")
    ]

    var cartTotal: Int { cart.reduce(0) { $0 + $1.subtotal } }
    var cartCount: Int { cart.reduce(0) { $0 + $1.quantity } }

    func add(_ product: ProduceProduct) {
        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartLine(product: product, quantity: 1))
        }
    }

    func updateQuantity(for line: CartLine, by change: Int) {
        guard let index = cart.firstIndex(where: { $0.id == line.id }) else { return }
        let newQuantity = cart[index].quantity + change
        if newQuantity > 0 {
            cart[index].quantity = newQuantity
        } else {
            cart.remove(at: index)
        }
    }

    func remove(_ line: CartLine) {
        cart.removeAll { $0.id == line.id }
    }

    func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        chatEntries.append(ChatEntry(author: .customer, text: trimmed))
        let reply = reply(for: trimmed)
        chatEntries.append(ChatEntry(author: .assistant, text: reply))
    }

    func sendSuggestion(_ suggestion: String) {
        send(suggestion)
    }

    func placeOrder(in context: ModelContext) {
        guard !cart.isEmpty else { return }
        let first = cart[0].product.name
        let summary = cart.map { "\($0.quantity) × \($0.product.name)" }.joined(separator: " · ")
        let reference = "VC-\(Int.random(in: 5800...7999))"
        let order = LocalOrder(reference: reference, title: first, itemSummary: summary, total: cartTotal + 1_250, status: "Preparing at the farm", deliveryProgress: 0.25, date: .now, isActive: true)
        context.insert(order)
        try? context.save()
        cart.removeAll()
    }

    private func reply(for input: String) -> String {
        let lowercased = input.lowercased()
        if lowercased.contains("mayian") {
            return "Mayian Farms is our 300-acre climate-smart model farm. It grows traceable organic produce, trains local producers, and anchors our quality system."
        }
        if lowercased.contains("m-pesa") || lowercased.contains("mpesa") {
            return "At checkout, choose M-Pesa and enter the Kenyan mobile number you want us to use. In this demo, the payment step is simulated locally."
        }
        if lowercased.contains("yield") {
            return "Mayian’s current season is tracking 18% ahead of its soil-health baseline, with cold-chain losses held below 3.5% across our active routes."
        }
        if lowercased.contains("delivery") || lowercased.contains("order") {
            return "Your active Verdant order is moving through a four-stage route: confirmed, preparing, out for delivery, and delivered. Open Orders for the live tracker."
        }
        return "Verdant Capital connects climate-smart growing, reliable cold-chain handling, and fresh retail. Ask about produce, deliveries, Mayian Farms, or investment opportunities."
    }
}

enum DemoSeeder {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<LocalOrder>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        let seedOrders = [
            LocalOrder(reference: "VC-4921", title: "Premium Seed Bundle", itemSummary: "2 × Premium seed bundle · 1 × Soil testing kit", total: 23_850, status: "Out for delivery", deliveryProgress: 0.80, date: .now.addingTimeInterval(-86_400), isActive: true),
            LocalOrder(reference: "VC-4802", title: "Organic Soil Amendment", itemSummary: "50 bags · Mayian Farms", total: 185_000, status: "Delivered", deliveryProgress: 1, date: .now.addingTimeInterval(-3_888_000), isActive: false),
            LocalOrder(reference: "VC-4755", title: "Heirloom Harvest Box", itemSummary: "Tomatoes · kale · basil", total: 4_760, status: "Delivered", deliveryProgress: 1, date: .now.addingTimeInterval(-6_912_000), isActive: false),
            LocalOrder(reference: "VC-4708", title: "Avocado Grower Case", itemSummary: "6 × Hass avocado box", total: 5_100, status: "Delivered", deliveryProgress: 1, date: .now.addingTimeInterval(-9_936_000), isActive: false)
        ]
        for order in seedOrders { context.insert(order) }
        try? context.save()
    }
}

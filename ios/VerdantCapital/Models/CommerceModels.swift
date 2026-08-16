import Foundation
import SwiftData

struct ProduceProduct: Identifiable, Hashable {
    let id: UUID
    let name: String
    let farm: String
    let price: Int
    let unit: String
    let detail: String
    let symbol: String
    let colorName: String
    let certified: String

    static let catalog: [ProduceProduct] = [
        ProduceProduct(id: UUID(), name: "Heirloom Tomatoes", farm: "Farm 42, Central Valley", price: 450, unit: "lb", detail: "Sweet, bright heirloom tomatoes grown in living soil and picked at peak color.", symbol: "tomato.fill", colorName: "Tomato", certified: "Organic"),
        ProduceProduct(id: UUID(), name: "Hass Avocados", farm: "Coastal Ridge Farms", price: 850, unit: "box", detail: "Creamy Hass avocados from regenerative coastal groves, packed for a generous family table.", symbol: "leaf.fill", colorName: "Avocado", certified: "Sustainable"),
        ProduceProduct(id: UUID(), name: "Heritage Pumpkins", farm: "Verdant North Estate", price: 1_200, unit: "each", detail: "Dense, nutty heritage pumpkins with an exceptional roast and a long kitchen life.", symbol: "sun.max.fill", colorName: "Pumpkin", certified: "Seasonal"),
        ProduceProduct(id: UUID(), name: "Rainbow Carrots", farm: "Mayian Farms", price: 620, unit: "bunch", detail: "A crisp bouquet of purple, gold, and orange carrots cultivated on our 300-acre model farm.", symbol: "carrot.fill", colorName: "Carrot", certified: "Organic"),
        ProduceProduct(id: UUID(), name: "Tender Kale", farm: "Central Valley", price: 380, unit: "bunch", detail: "Tender, mineral-rich kale grown with water-wise, climate-smart production practices.", symbol: "leaf.arrow.circlepath", colorName: "Kale", certified: "Organic"),
        ProduceProduct(id: UUID(), name: "Fresh Basil", farm: "Farm 42, Central Valley", price: 300, unit: "bunch", detail: "Fragrant Genovese basil, cooled immediately after harvest for a brighter finish.", symbol: "sprout.fill", colorName: "Basil", certified: "Fresh today")
    ]
}

struct CartLine: Identifiable, Hashable {
    let product: ProduceProduct
    var quantity: Int
    var id: UUID { product.id }
    var subtotal: Int { product.price * quantity }
}

enum PaymentMethod: String, CaseIterable, Identifiable {
    case mpesa = "M-Pesa"
    case card = "Card"
    var id: String { rawValue }
    var symbol: String { self == .mpesa ? "iphone" : "creditcard.fill" }
}

struct ChatEntry: Identifiable, Hashable {
    enum Author { case customer, assistant }
    let id = UUID()
    let author: Author
    var text: String
}

@Model
final class LocalOrder {
    @Attribute(.unique) var reference: String
    var title: String
    var itemSummary: String
    var total: Int
    var status: String
    var deliveryProgress: Double
    var date: Date
    var isActive: Bool

    init(reference: String, title: String, itemSummary: String, total: Int, status: String, deliveryProgress: Double, date: Date, isActive: Bool) {
        self.reference = reference
        self.title = title
        self.itemSummary = itemSummary
        self.total = total
        self.status = status
        self.deliveryProgress = deliveryProgress
        self.date = date
        self.isActive = isActive
    }
}

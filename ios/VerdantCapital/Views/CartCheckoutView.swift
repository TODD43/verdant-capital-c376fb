import SwiftUI
import SwiftData

struct CartView: View {
    @Environment(VerdantStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showingCheckout = false

    var body: some View {
        NavigationStack {
            Group {
                if store.cart.isEmpty {
                    VStack(spacing: AppTokens.Spacing.md) {
                        Image(systemName: "basket")
                            .font(.system(size: 54, weight: .medium))
                            .foregroundStyle(AppTokens.accent)
                        Text("Your basket is ready")
                            .font(AppTokens.titleFont)
                            .foregroundStyle(AppTokens.text)
                        Text("Choose from today’s fresh harvest to begin an order.")
                            .font(AppTokens.bodyFont)
                            .foregroundStyle(AppTokens.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(AppTokens.Spacing.huge)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                            ForEach(store.cart) { line in
                                CartLineRow(line: line)
                            }
                            checkoutSummary
                        }
                        .padding(AppTokens.screenMargin)
                    }
                    .safeAreaInset(edge: .bottom) {
                        Button { showingCheckout = true } label: {
                            Text("Continue to checkout · KSh \(store.cartTotal.formatted())")
                        }
                        .buttonStyle(PrimaryCTAStyle())
                        .padding(.horizontal, AppTokens.screenMargin)
                        .padding(.vertical, AppTokens.Spacing.sm)
                        .background(AppTokens.background.opacity(0.94))
                    }
                }
            }
            .background(AppTokens.background)
            .navigationTitle("Basket")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(AppTokens.headlineFont)
                        .foregroundStyle(AppTokens.accent)
                }
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutView()
            }
        }
    }

    private var checkoutSummary: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text("Summary")
                .font(AppTokens.titleFont)
                .foregroundStyle(AppTokens.text)
            PriceRow(label: "Harvest subtotal", amount: store.cartTotal)
            PriceRow(label: "Cold-chain delivery", amount: 1_250)
            Divider()
                .overlay(AppTokens.hairline)
            PriceRow(label: "Total", amount: store.cartTotal + 1_250, emphasis: true)
        }
        .padding(AppTokens.Spacing.md)
        .verdantCard()
    }
}

private struct CartLineRow: View {
    @Environment(VerdantStore.self) private var store
    let line: CartLine

    var body: some View {
        HStack(spacing: AppTokens.Spacing.md) {
            ProductArt(product: line.product, compact: true)
                .frame(width: 72, height: 72)
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                Text(line.product.name)
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.text)
                    .lineLimit(2)
                Text("KSh \(line.product.price.formatted()) / \(line.product.unit)")
                    .font(AppTokens.captionFont)
                    .foregroundStyle(AppTokens.secondaryText)
                QuantityControl(quantity: line.quantity, decrement: { store.updateQuantity(for: line, by: -1) }, increment: { store.updateQuantity(for: line, by: 1) })
            }
            Spacer(minLength: AppTokens.Spacing.xs)
            Text("KSh \(line.subtotal.formatted())")
                .font(AppTokens.headlineFont)
                .foregroundStyle(AppTokens.primary)
                .fixedSize()
        }
        .padding(AppTokens.Spacing.sm)
        .verdantCard()
    }
}

struct CheckoutView: View {
    @Environment(VerdantStore.self) private var store
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var placed = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxl) {
                    payment
                    review
                    Text("Payments are simulated locally for this demo. No funds will move.")
                        .font(AppTokens.captionFont)
                        .foregroundStyle(AppTokens.secondaryText)
                }
                .padding(AppTokens.screenMargin)
                .padding(.bottom, AppTokens.Spacing.xl)
            }
            .background(AppTokens.background)
            .navigationTitle("Checkout")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .font(AppTokens.headlineFont)
                        .foregroundStyle(AppTokens.accent)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if placed {
                    VStack(spacing: AppTokens.Spacing.xs) {
                        Label("Order confirmed", systemImage: "checkmark.circle.fill")
                            .font(AppTokens.headlineFont)
                            .foregroundStyle(AppTokens.positive)
                        Text("Your new order appears in Orders.")
                            .font(AppTokens.captionFont)
                            .foregroundStyle(AppTokens.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(AppTokens.Spacing.md)
                    .background(AppTokens.background.opacity(0.94))
                } else {
                    Button {
                        store.placeOrder(in: modelContext)
                        placed = true
                    } label: {
                        Text("Place simulated order · KSh \((store.cartTotal + 1_250).formatted())")
                    }
                    .buttonStyle(PrimaryCTAStyle())
                    .padding(.horizontal, AppTokens.screenMargin)
                    .padding(.vertical, AppTokens.Spacing.sm)
                    .background(AppTokens.background.opacity(0.94))
                }
            }
        }
    }

    private var payment: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            SectionTitle(title: "Payment", actionTitle: nil, action: nil)
            ForEach(PaymentMethod.allCases) { method in
                Button { store.paymentMethod = method } label: {
                    HStack(spacing: AppTokens.Spacing.md) {
                        Image(systemName: method.symbol)
                            .font(.title3)
                            .foregroundStyle(store.paymentMethod == method ? AppTokens.accent : AppTokens.secondaryText)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                            Text(method.rawValue)
                                .font(AppTokens.headlineFont)
                                .foregroundStyle(AppTokens.text)
                            Text(method == .mpesa ? "Prompt sent to your phone" : "Visa ending in 4408")
                                .font(AppTokens.captionFont)
                                .foregroundStyle(AppTokens.secondaryText)
                        }
                        Spacer()
                        Image(systemName: store.paymentMethod == method ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(store.paymentMethod == method ? AppTokens.accent : AppTokens.secondaryText)
                    }
                    .padding(AppTokens.Spacing.md)
                    .verdantCard()
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var review: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            SectionTitle(title: "Review", actionTitle: nil, action: nil)
            VStack(spacing: AppTokens.Spacing.sm) {
                PriceRow(label: "Produce", amount: store.cartTotal)
                PriceRow(label: "Cold-chain delivery", amount: 1_250)
                Divider().overlay(AppTokens.hairline)
                PriceRow(label: "Total", amount: store.cartTotal + 1_250, emphasis: true)
            }
            .padding(AppTokens.Spacing.md)
            .verdantCard()
        }
    }
}

private struct PriceRow: View {
    let label: String
    let amount: Int
    var emphasis = false

    var body: some View {
        HStack {
            Text(label)
                .font(emphasis ? AppTokens.headlineFont : AppTokens.bodyFont)
                .foregroundStyle(emphasis ? AppTokens.text : AppTokens.secondaryText)
            Spacer()
            Text("KSh \(amount.formatted())")
                .font(emphasis ? AppTokens.titleFont : AppTokens.bodyFont)
                .foregroundStyle(emphasis ? AppTokens.primary : AppTokens.text)
                .monospacedDigit()
        }
    }
}

#Preview {
    CartView()
        .environment(VerdantStore())
        .modelContainer(for: [LocalOrder.self], inMemory: true)
}

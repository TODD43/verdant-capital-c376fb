import SwiftUI
import SwiftData

struct OrdersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LocalOrder.date, order: .reverse) private var orders: [LocalOrder]

    private var activeOrders: [LocalOrder] { orders.filter(\.isActive) }
    private var pastOrders: [LocalOrder] { orders.filter { !$0.isActive } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxl) {
                    if let active = activeOrders.first {
                        activeTracker(active)
                    }

                    VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                        SectionTitle(title: "History", actionTitle: nil, action: nil)
                        ForEach(pastOrders) { order in
                            OrderRow(order: order)
                        }
                    }
                }
                .padding(.horizontal, AppTokens.screenMargin)
                .padding(.top, AppTokens.Spacing.sm)
                .padding(.bottom, AppTokens.Spacing.huge)
            }
            .background(AppTokens.background)
            .navigationTitle("Orders")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        advanceDelivery()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundStyle(AppTokens.accent)
                    }
                    .accessibilityLabel("Advance active delivery")
                }
            }
        }
    }

    private func activeTracker(_ order: LocalOrder) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            HStack {
                Label(order.status, systemImage: "truck.box.fill")
                    .font(AppTokens.captionFont)
                    .foregroundStyle(AppTokens.positive)
                    .padding(.horizontal, AppTokens.Spacing.sm)
                    .padding(.vertical, AppTokens.Spacing.xs)
                    .background(AppTokens.accentSoft, in: Capsule())
                Spacer()
                Text(order.reference)
                    .font(AppTokens.captionFont)
                    .foregroundStyle(AppTokens.secondaryText)
            }
            Text("Your harvest is moving.")
                .font(AppTokens.displayFont)
                .foregroundStyle(AppTokens.text)
            Text(order.itemSummary)
                .font(AppTokens.bodyFont)
                .foregroundStyle(AppTokens.secondaryText)
            ProgressView(value: order.deliveryProgress)
                .tint(AppTokens.accent)
            HStack {
                Text("Farm")
                Spacer()
                Text("Cold chain")
                Spacer()
                Text("Doorstep")
            }
            .font(AppTokens.captionFont)
            .foregroundStyle(AppTokens.secondaryText)
        }
        .padding(AppTokens.Spacing.xl)
        .background(AppTokens.paper, in: RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous))
    }

    private func advanceDelivery() {
        guard let order = activeOrders.first else { return }
        if order.deliveryProgress < 0.5 {
            order.deliveryProgress = 0.55
            order.status = "With our cold-chain team"
        } else if order.deliveryProgress < 0.9 {
            order.deliveryProgress = 0.9
            order.status = "Out for delivery"
        } else {
            order.deliveryProgress = 1
            order.status = "Delivered"
            order.isActive = false
        }
        try? modelContext.save()
    }
}

private struct OrderRow: View {
    let order: LocalOrder

    var body: some View {
        HStack(spacing: AppTokens.Spacing.md) {
            Image(systemName: order.isActive ? "shippingbox.fill" : "checkmark.seal.fill")
                .font(.title2)
                .foregroundStyle(order.isActive ? AppTokens.accent : AppTokens.positive)
                .frame(width: 40, height: 40)
                .background(AppTokens.accentSoft, in: Circle())
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                Text(order.title)
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.text)
                    .lineLimit(2)
                Text("\(order.reference) · \(order.status)")
                    .font(AppTokens.captionFont)
                    .foregroundStyle(AppTokens.secondaryText)
            }
            Spacer()
            Text("KSh \(order.total.formatted())")
                .font(AppTokens.headlineFont)
                .foregroundStyle(AppTokens.primary)
                .fixedSize()
        }
        .padding(AppTokens.Spacing.md)
        .verdantCard()
    }
}

#Preview {
    OrdersView()
        .modelContainer(for: [LocalOrder.self], inMemory: true)
}

import SwiftUI

struct ProductArt: View {
    let product: ProduceProduct
    var compact = false

    private var colors: [Color] {
        switch product.colorName {
        case "Tomato": return [Color.red.opacity(0.72), Color.orange.opacity(0.72)]
        case "Avocado": return [AppTokens.accent, AppTokens.primary]
        case "Pumpkin": return [Color.orange.opacity(0.78), AppTokens.warning]
        case "Carrot": return [Color.orange.opacity(0.72), Color.yellow.opacity(0.72)]
        case "Kale": return [AppTokens.primary, AppTokens.accent]
        default: return [AppTokens.accent.opacity(0.85), AppTokens.paper]
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: compact ? 56 : 112, height: compact ? 56 : 112)
                .offset(x: compact ? 16 : 38, y: compact ? -20 : -44)
            Image(systemName: product.symbol)
                .font(compact ? .title2 : .system(size: 52, weight: .medium))
                .foregroundStyle(AppTokens.onAccent.opacity(0.94))
                .symbolRenderingMode(.hierarchical)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTokens.radiusControl, style: .continuous))
        .accessibilityLabel(product.name)
    }
}

struct SectionTitle: View {
    let title: String
    let actionTitle: String?
    let action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AppTokens.titleFont)
                .foregroundStyle(AppTokens.text)
            Spacer()
            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTokens.captionFont)
                        .foregroundStyle(AppTokens.accent)
                }
                .frame(minHeight: 44)
            }
        }
    }
}

struct QuantityControl: View {
    let quantity: Int
    let decrement: () -> Void
    let increment: () -> Void

    var body: some View {
        HStack(spacing: AppTokens.Spacing.xs) {
            Button(action: decrement) {
                Image(systemName: "minus")
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .foregroundStyle(AppTokens.primary)

            Text("\(quantity)")
                .font(AppTokens.headlineFont)
                .frame(minWidth: 20)
                .monospacedDigit()

            Button(action: increment) {
                Image(systemName: "plus")
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .foregroundStyle(AppTokens.primary)
        }
        .background(AppTokens.accentSoft, in: Capsule())
    }
}

#Preview {
    VStack(spacing: AppTokens.Spacing.md) {
        ProductArt(product: ProduceProduct.catalog[0])
            .frame(height: 180)
        QuantityControl(quantity: 2, decrement: {}, increment: {})
    }
    .padding(AppTokens.Spacing.lg)
    .background(AppTokens.background)
}

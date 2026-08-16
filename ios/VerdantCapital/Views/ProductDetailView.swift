import SwiftUI

struct ProductDetailView: View {
    @Environment(VerdantStore.self) private var store
    let product: ProduceProduct
    @State private var added = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
                ProductArt(product: product)
                    .frame(height: 300)
                    .padding(.top, AppTokens.Spacing.xs)

                VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                    Text(product.certified)
                        .font(AppTokens.eyebrowFont)
                        .kerning(1)
                        .foregroundStyle(AppTokens.accent)
                    Text(product.name)
                        .font(AppTokens.displayFont)
                        .foregroundStyle(AppTokens.text)
                    Text(product.farm)
                        .font(AppTokens.headlineFont)
                        .foregroundStyle(AppTokens.secondaryText)
                    Text(product.detail)
                        .font(AppTokens.bodyFont)
                        .foregroundStyle(AppTokens.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                        Text("Harvest price")
                            .font(AppTokens.captionFont)
                            .foregroundStyle(AppTokens.secondaryText)
                        Text("KSh \(product.price.formatted()) / \(product.unit)")
                            .font(AppTokens.titleFont)
                            .foregroundStyle(AppTokens.primary)
                    }
                    Spacer()
                    Label("Traceable", systemImage: "checkmark.seal.fill")
                        .font(AppTokens.captionFont)
                        .foregroundStyle(AppTokens.accent)
                }
                .padding(AppTokens.Spacing.md)
                .verdantCard()

                VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                    SectionTitle(title: "From farm to table", actionTitle: nil, action: nil)
                    DetailRow(symbol: "leaf.fill", title: "Climate-smart growing", detail: "Water-wise practices and living soil.")
                    DetailRow(symbol: "snowflake", title: "Cooled early", detail: "Cold-chain care locks in freshness.")
                    DetailRow(symbol: "shippingbox.fill", title: "Delivered with care", detail: "Track each handoff after checkout.")
                }
            }
            .padding(.horizontal, AppTokens.screenMargin)
            .padding(.bottom, AppTokens.Spacing.xxl)
        }
        .background(AppTokens.background)
        .navigationTitle("Produce")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                store.add(product)
                added = true
            } label: {
                Text(added ? "Added to basket" : "Add to basket")
            }
            .buttonStyle(PrimaryCTAStyle())
            .padding(.horizontal, AppTokens.screenMargin)
            .padding(.vertical, AppTokens.Spacing.sm)
            .background(AppTokens.background.opacity(0.94))
        }
    }
}

private struct DetailRow: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: AppTokens.Spacing.md) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(AppTokens.accent)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                Text(title)
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.text)
                Text(detail)
                    .font(AppTokens.bodyFont)
                    .foregroundStyle(AppTokens.secondaryText)
            }
        }
        .padding(AppTokens.Spacing.md)
        .verdantCard()
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: ProduceProduct.catalog[0])
    }
    .environment(VerdantStore())
}

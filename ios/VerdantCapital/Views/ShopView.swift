import SwiftUI

struct ShopView: View {
    @Environment(VerdantStore.self) private var store
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var query = ""
    @State private var showingCart = false

    private var products: [ProduceProduct] {
        guard !query.isEmpty else { return ProduceProduct.catalog }
        return ProduceProduct.catalog.filter {
            $0.name.localizedCaseInsensitiveContains(query) || $0.farm.localizedCaseInsensitiveContains(query)
        }
    }

    private var columns: [GridItem] {
        let count = dynamicTypeSize.isAccessibilitySize ? 1 : 2
        return Array(repeating: GridItem(.flexible(), spacing: AppTokens.Spacing.md), count: count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxl) {
                    searchField
                    harvestHero
                    ecosystem
                    productCollection
                }
                .padding(.horizontal, AppTokens.screenMargin)
                .padding(.top, AppTokens.Spacing.sm)
                .padding(.bottom, AppTokens.Spacing.huge)
            }
            .background(AppTokens.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingCart = true } label: {
                        Image(systemName: "basket.fill")
                            .foregroundStyle(AppTokens.primary)
                            .overlay(alignment: .topTrailing) {
                                if store.cartCount > 0 {
                                    Text("\(store.cartCount)")
                                        .font(AppTokens.eyebrowFont)
                                        .foregroundStyle(AppTokens.onAccent)
                                        .padding(AppTokens.Spacing.xxs)
                                        .background(AppTokens.accent, in: Circle())
                                        .offset(x: AppTokens.Spacing.xs, y: -AppTokens.Spacing.xxs)
                                }
                            }
                    }
                    .accessibilityLabel("Cart, \(store.cartCount) items")
                }
            }
            .sheet(isPresented: $showingCart) {
                CartView()
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: AppTokens.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTokens.secondaryText)
            TextField("Search produce or farms", text: $query)
                .font(AppTokens.bodyFont)
                .foregroundStyle(AppTokens.text)
        }
        .padding(AppTokens.Spacing.md)
        .background(AppTokens.surface, in: RoundedRectangle(cornerRadius: AppTokens.radiusControl, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AppTokens.radiusControl, style: .continuous)
                .stroke(AppTokens.hairline, lineWidth: 1)
        }
    }

    private var harvestHero: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            Text("SUSTAINABLE YIELDS")
                .font(AppTokens.eyebrowFont)
                .kerning(1.1)
                .foregroundStyle(AppTokens.primary)
            Text("Harvested with care.")
                .font(AppTokens.displayFont)
                .foregroundStyle(AppTokens.primary)
            Text("A considered selection of traceable organic produce from the Verdant ecosystem.")
                .font(AppTokens.bodyFont)
                .foregroundStyle(AppTokens.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
            NavigationLink {
                DiscoverView()
            } label: {
                Text("Explore the ecosystem")
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.onAccent)
                    .frame(minHeight: 44)
                    .padding(.horizontal, AppTokens.md)
                    .background(AppTokens.primary, in: Capsule())
            }
        }
        .padding(AppTokens.Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            LinearGradient(colors: [AppTokens.accentSoft, AppTokens.paper], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous))
    }

    private var ecosystem: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            SectionTitle(title: "Ecosystem", actionTitle: "Discover") { }
            ScrollView(.horizontal) {
                HStack(spacing: AppTokens.Spacing.sm) {
                    EcosystemChip(title: "Mayian Farms", symbol: "leaf.fill", detail: "Growing")
                    EcosystemChip(title: "Celine Valley", symbol: "snowflake", detail: "Cold chain")
                    EcosystemChip(title: "Jambo Fresh", symbol: "storefront.fill", detail: "Retail")
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private var productCollection: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            SectionTitle(title: query.isEmpty ? "Fresh harvest" : "Results", actionTitle: nil, action: nil)
            LazyVGrid(columns: columns, spacing: AppTokens.Spacing.md) {
                ForEach(products) { product in
                    NavigationLink(value: product) {
                        ProductCard(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(for: ProduceProduct.self) { product in
                ProductDetailView(product: product)
            }
        }
    }
}

private struct EcosystemChip: View {
    let title: String
    let symbol: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(AppTokens.accent)
            Text(title)
                .font(AppTokens.headlineFont)
                .foregroundStyle(AppTokens.text)
            Text(detail)
                .font(AppTokens.captionFont)
                .foregroundStyle(AppTokens.secondaryText)
        }
        .padding(AppTokens.Spacing.md)
        .frame(width: 148, alignment: .leading)
        .verdantCard()
    }
}

private struct ProductCard: View {
    @Environment(VerdantStore.self) private var store
    let product: ProduceProduct

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            ProductArt(product: product)
                .frame(height: 146)
            Text(product.certified)
                .font(AppTokens.eyebrowFont)
                .foregroundStyle(AppTokens.accent)
            Text(product.name)
                .font(AppTokens.titleFont)
                .foregroundStyle(AppTokens.text)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(product.farm)
                .font(AppTokens.captionFont)
                .foregroundStyle(AppTokens.secondaryText)
                .lineLimit(2)
            HStack(alignment: .center) {
                Text("KSh \(product.price.formatted())")
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.primary)
                Text("/ \(product.unit)")
                    .font(AppTokens.captionFont)
                    .foregroundStyle(AppTokens.secondaryText)
                Spacer()
                Button { store.add(product) } label: {
                    Image(systemName: "plus")
                        .font(AppTokens.headlineFont)
                        .foregroundStyle(AppTokens.onAccent)
                        .frame(width: 44, height: 44)
                        .background(AppTokens.primary, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add \(product.name)")
            }
        }
        .padding(AppTokens.Spacing.sm)
        .verdantCard()
    }
}

#Preview {
    ShopView()
        .environment(VerdantStore())
}

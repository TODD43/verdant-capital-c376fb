import SwiftUI

struct DiscoverView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var selectedCompany: Company?

    private var columns: [GridItem] {
        let count = dynamicTypeSize.isAccessibilitySize ? 1 : 2
        return Array(repeating: GridItem(.flexible(), spacing: AppTokens.Spacing.md), count: count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxl) {
                    investmentHero
                    opportunitySection
                    ecosystemSection
                }
                .padding(.horizontal, AppTokens.screenMargin)
                .padding(.top, AppTokens.Spacing.sm)
                .padding(.bottom, AppTokens.Spacing.huge)
            }
            .background(AppTokens.background)
            .navigationTitle("Discover")
            .sheet(item: $selectedCompany) { company in
                CompanyDetailView(company: company)
            }
        }
    }

    private var investmentHero: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            Text("VERDANT CAPITAL")
                .font(AppTokens.eyebrowFont)
                .kerning(1.1)
                .foregroundStyle(AppTokens.accent)
            Text("One value chain.\nThree companies.")
                .font(AppTokens.displayFont)
                .foregroundStyle(AppTokens.text)
            Text("From regenerative growing to cold-chain infrastructure and fresh retail, each business strengthens the next.")
                .font(AppTokens.bodyFont)
                .foregroundStyle(AppTokens.secondaryText)
        }
        .padding(AppTokens.Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTokens.surface, in: RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous)
                .stroke(AppTokens.hairline, lineWidth: 1)
        }
    }

    private var opportunitySection: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            SectionTitle(title: "Opportunities", actionTitle: nil, action: nil)
            ForEach(Opportunity.all) { opportunity in
                HStack(alignment: .top, spacing: AppTokens.Spacing.md) {
                    Image(systemName: opportunity.symbol)
                        .font(.title3)
                        .foregroundStyle(AppTokens.accent)
                        .frame(width: 40, height: 40)
                        .background(AppTokens.accentSoft, in: Circle())
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                        Text(opportunity.title)
                            .font(AppTokens.titleFont)
                            .foregroundStyle(AppTokens.text)
                        Text(opportunity.detail)
                            .font(AppTokens.bodyFont)
                            .foregroundStyle(AppTokens.secondaryText)
                    }
                }
                .padding(AppTokens.Spacing.md)
                .verdantCard()
            }
        }
    }

    private var ecosystemSection: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            SectionTitle(title: "Companies", actionTitle: nil, action: nil)
            LazyVGrid(columns: columns, spacing: AppTokens.Spacing.md) {
                ForEach(Company.all) { company in
                    Button { selectedCompany = company } label: {
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                            Image(systemName: company.symbol)
                                .font(.title2)
                                .foregroundStyle(AppTokens.accent)
                            Text(company.name)
                                .font(AppTokens.titleFont)
                                .foregroundStyle(AppTokens.text)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(company.role)
                                .font(AppTokens.captionFont)
                                .foregroundStyle(AppTokens.secondaryText)
                        }
                        .padding(AppTokens.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .verdantCard()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct Opportunity: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let symbol: String
    static let all = [
        Opportunity(title: "Growth equity", detail: "Direct participation in resilient, high-growth agribusinesses.", symbol: "chart.line.uptrend.xyaxis"),
        Opportunity(title: "Impact partnerships", detail: "Measurable environmental and community outcomes alongside returns.", symbol: "globe.africa.fill"),
        Opportunity(title: "Infrastructure", detail: "Cold-chain, processing, and water-efficient systems that reduce waste.", symbol: "building.2.fill")
    ]
}

private struct Company: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let role: String
    let symbol: String
    let detail: String
    static let all = [
        Company(name: "Mayian Farms", role: "Growing", symbol: "leaf.fill", detail: "Our 300-acre climate-smart model farm grows certified produce, trains smallholder networks, and sets our regenerative production standard."),
        Company(name: "Celine Green Valley", role: "Cold chain", symbol: "snowflake", detail: "A five-station cold-chain network reduces post-harvest loss and connects growers to reliable market demand."),
        Company(name: "Jambo Fresh", role: "Retail", symbol: "storefront.fill", detail: "Our direct retail arm brings farm-fresh produce to households while finding a dignified market for nutritious Grade B harvests.")
    ]
}

private struct CompanyDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let company: Company

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
                    Image(systemName: company.symbol)
                        .font(.system(size: 56, weight: .medium))
                        .foregroundStyle(AppTokens.accent)
                        .frame(width: 104, height: 104)
                        .background(AppTokens.accentSoft, in: Circle())
                    Text(company.name)
                        .font(AppTokens.displayFont)
                        .foregroundStyle(AppTokens.text)
                    Text(company.detail)
                        .font(AppTokens.bodyFont)
                        .foregroundStyle(AppTokens.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Label("Traceable operations", systemImage: "checkmark.seal.fill")
                        Label("Sustainable value creation", systemImage: "leaf.fill")
                        Label("Local demo information", systemImage: "info.circle.fill")
                    }
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.primary)
                    .padding(AppTokens.Spacing.md)
                    .verdantCard()
                }
                .padding(AppTokens.screenMargin)
            }
            .background(AppTokens.background)
            .navigationTitle(company.role)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(AppTokens.headlineFont)
                        .foregroundStyle(AppTokens.accent)
                }
            }
        }
    }
}

#Preview {
    DiscoverView()
}

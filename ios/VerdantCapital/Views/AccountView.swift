import SwiftUI

struct AccountView: View {
    @Environment(VerdantStore.self) private var store
    @State private var showingPayments = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxl) {
                    profileCard
                    if store.isSignedIn {
                        accountTools
                    } else {
                        signInCard
                    }
                }
                .padding(.horizontal, AppTokens.screenMargin)
                .padding(.top, AppTokens.Spacing.sm)
                .padding(.bottom, AppTokens.Spacing.huge)
            }
            .background(AppTokens.background)
            .navigationTitle("Account")
            .sheet(isPresented: $showingPayments) { PaymentMethodsView() }
        }
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            HStack(spacing: AppTokens.Spacing.md) {
                Image(systemName: store.isSignedIn ? "person.crop.circle.fill" : "person.crop.circle")
                    .font(.system(size: 56))
                    .foregroundStyle(AppTokens.accent)
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                    Text(store.isSignedIn ? "Eleanor Vance" : "Verdant guest")
                        .font(AppTokens.titleFont)
                        .foregroundStyle(AppTokens.text)
                    Text(store.isSignedIn ? "Institutional partner" : "Browse freely. Sign in at your pace.")
                        .font(AppTokens.bodyFont)
                        .foregroundStyle(AppTokens.secondaryText)
                }
            }
            if store.isSignedIn {
                Label("Verified partner", systemImage: "checkmark.seal.fill")
                    .font(AppTokens.captionFont)
                    .foregroundStyle(AppTokens.positive)
            }
        }
        .padding(AppTokens.Spacing.xl)
        .background(AppTokens.paper, in: RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous))
    }

    private var signInCard: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            Text("A calmer checkout")
                .font(AppTokens.titleFont)
                .foregroundStyle(AppTokens.text)
            Text("Save your payment preference and see order updates in one place. This sign-in is simulated locally.")
                .font(AppTokens.bodyFont)
                .foregroundStyle(AppTokens.secondaryText)
            Button { store.isSignedIn = true } label: {
                Text("Sign in to Verdant")
            }
            .buttonStyle(PrimaryCTAStyle())
        }
        .padding(AppTokens.Spacing.md)
        .verdantCard()
    }

    private var accountTools: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            SectionTitle(title: "Account", actionTitle: nil, action: nil)
            AccountRow(symbol: "creditcard.fill", title: "Payment methods", detail: "M-Pesa and saved card") { showingPayments = true }
            AccountRow(symbol: "bell.badge.fill", title: "Order updates", detail: "Delivery status is on") { }
            AccountRow(symbol: "rectangle.portrait.and.arrow.right", title: "Sign out", detail: "Return to guest browsing") { store.isSignedIn = false }
        }
    }
}

private struct AccountRow: View {
    let symbol: String
    let title: String
    let detail: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTokens.Spacing.md) {
                Image(systemName: symbol)
                    .font(.title3)
                    .foregroundStyle(AppTokens.accent)
                    .frame(width: 40, height: 40)
                    .background(AppTokens.accentSoft, in: Circle())
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                    Text(title)
                        .font(AppTokens.headlineFont)
                        .foregroundStyle(AppTokens.text)
                    Text(detail)
                        .font(AppTokens.captionFont)
                        .foregroundStyle(AppTokens.secondaryText)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppTokens.secondaryText)
            }
            .padding(AppTokens.Spacing.md)
            .verdantCard()
        }
        .buttonStyle(.plain)
    }
}

private struct PaymentMethodsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                Text("Saved payment methods are displayed locally for this V1 demo.")
                    .font(AppTokens.bodyFont)
                    .foregroundStyle(AppTokens.secondaryText)
                AccountPaymentRow(symbol: "iphone", title: "M-Pesa", detail: "254 7••• 824")
                AccountPaymentRow(symbol: "creditcard.fill", title: "Visa", detail: "Ending in 4408")
                Spacer()
            }
            .padding(AppTokens.screenMargin)
            .background(AppTokens.background)
            .navigationTitle("Payments")
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

private struct AccountPaymentRow: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: AppTokens.Spacing.md) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(AppTokens.accent)
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                Text(title)
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.text)
                Text(detail)
                    .font(AppTokens.captionFont)
                    .foregroundStyle(AppTokens.secondaryText)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(AppTokens.positive)
        }
        .padding(AppTokens.Spacing.md)
        .verdantCard()
    }
}

#Preview {
    AccountView()
        .environment(VerdantStore())
}

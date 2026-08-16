import SwiftUI
import SwiftData

@main
struct VerdantCapitalApp: App {
    @State private var store = VerdantStore()

    var body: some Scene {
        WindowGroup {
            VerdantRootView()
                .environment(store)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [LocalOrder.self])
    }
}

struct VerdantRootView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            ShopView()
                .tabItem { Label("Shop", systemImage: "basket") }

            DiscoverView()
                .tabItem { Label("Discover", systemImage: "leaf") }

            AssistantView()
                .tabItem { Label("Assistant", systemImage: "sparkles") }

            OrdersView()
                .tabItem { Label("Orders", systemImage: "shippingbox") }

            AccountView()
                .tabItem { Label("Account", systemImage: "person.crop.circle") }
        }
        .tint(AppTokens.accent)
        .task { DemoSeeder.seedIfNeeded(context: modelContext) }
    }
}

#Preview {
    VerdantRootView()
        .environment(VerdantStore())
        .modelContainer(for: [LocalOrder.self], inMemory: true)
}

import SwiftUI

struct AssistantView: View {
    @Environment(VerdantStore.self) private var store
    @State private var draft = ""

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: AppTokens.Spacing.lg) {
                        ForEach(store.chatEntries) { entry in
                            ChatBubble(entry: entry)
                                .id(entry.id)
                        }
                        promptSuggestions
                    }
                    .padding(.horizontal, AppTokens.screenMargin)
                    .padding(.top, AppTokens.Spacing.md)
                    .padding(.bottom, AppTokens.Spacing.md)
                }
                .background(AppTokens.background)
                .navigationTitle("Verdant guide")
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    composer
                }
                .onChange(of: store.chatEntries.count) { _, _ in
                    guard let lastID = store.chatEntries.last?.id else { return }
                    withAnimation { proxy.scrollTo(lastID, anchor: .bottom) }
                }
            }
        }
    }

    private var promptSuggestions: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text("Ask about")
                .font(AppTokens.titleFont)
                .foregroundStyle(AppTokens.text)
            ForEach(["Tell me about Mayian Farms", "How do I pay with M-Pesa?", "Show recent crop yield statistics"], id: \.self) { suggestion in
                Button { store.sendSuggestion(suggestion) } label: {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(AppTokens.accent)
                        Text(suggestion)
                            .font(AppTokens.bodyFont)
                            .foregroundStyle(AppTokens.text)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(AppTokens.secondaryText)
                    }
                    .padding(AppTokens.Spacing.md)
                    .verdantCard()
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var composer: some View {
        HStack(spacing: AppTokens.Spacing.sm) {
            TextField("Ask about Verdant", text: $draft)
                .font(AppTokens.bodyFont)
                .submitLabel(.send)
                .onSubmit(send)
            Button(action: send) {
                Image(systemName: "arrow.up")
                    .font(AppTokens.headlineFont)
                    .foregroundStyle(AppTokens.onAccent)
                    .frame(width: 44, height: 44)
                    .background(AppTokens.primary, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Send message")
        }
        .padding(AppTokens.Spacing.xs)
        .padding(.leading, AppTokens.Spacing.sm)
        .background(AppTokens.surface, in: Capsule())
        .overlay { Capsule().stroke(AppTokens.hairline, lineWidth: 1) }
        .padding(.horizontal, AppTokens.screenMargin)
        .padding(.vertical, AppTokens.Spacing.sm)
        .background(AppTokens.background.opacity(0.96))
    }

    private func send() {
        store.send(draft)
        draft = ""
    }
}

private struct ChatBubble: View {
    let entry: ChatEntry

    var body: some View {
        HStack {
            if entry.author == .customer { Spacer(minLength: AppTokens.Spacing.xl) }
            Text(entry.text)
                .font(AppTokens.bodyFont)
                .foregroundStyle(entry.author == .customer ? AppTokens.onAccent : AppTokens.text)
                .padding(AppTokens.Spacing.md)
                .background(entry.author == .customer ? AppTokens.primary : AppTokens.surface, in: RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous))
                .overlay {
                    if entry.author == .assistant {
                        RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous)
                            .stroke(AppTokens.hairline, lineWidth: 1)
                    }
                }
            if entry.author == .assistant { Spacer(minLength: AppTokens.Spacing.xl) }
        }
    }
}

#Preview {
    AssistantView()
        .environment(VerdantStore())
}

// 10x primitive: granola/design-tokens v1
import SwiftUI

/// Verdant Capital's single visual source of truth, rethemed from the Granola editorial language.
enum AppTokens {
    static let background = Color(red: 0.969, green: 0.973, blue: 0.957)
    static let surface = Color.white
    static let primary = Color(red: 0.118, green: 0.169, blue: 0.071)
    static let accent = Color(red: 0.420, green: 0.557, blue: 0.239)
    static let text = Color(red: 0.118, green: 0.106, blue: 0.090)
    static let secondaryText = Color(red: 0.345, green: 0.365, blue: 0.310)
    static let accentSoft = accent.opacity(0.14)
    static let paper = Color(red: 0.966, green: 0.949, blue: 0.922)
    static let sand = Color(red: 0.929, green: 0.910, blue: 0.866)
    static let positive = Color(red: 0.245, green: 0.486, blue: 0.278)
    static let warning = Color(red: 0.650, green: 0.454, blue: 0.098)
    static let hairline = primary.opacity(0.10)
    static let onAccent = Color.white

    static let radiusCard: CGFloat = 14
    static let radiusControl: CGFloat = 10
    static let screenMargin: CGFloat = 20

    static let displayFont = Font.system(size: 34, weight: .bold, design: .serif)
    static let titleFont = Font.system(.title2, design: .serif, weight: .semibold)
    static let headlineFont = Font.system(.headline, design: .default, weight: .semibold)
    static let bodyFont = Font.system(.body, design: .default)
    static let captionFont = Font.system(.caption, design: .default, weight: .medium)
    static let eyebrowFont = Font.system(.caption2, design: .default, weight: .semibold)

    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let huge: CGFloat = 48
    }
}

struct PrimaryCTAStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTokens.headlineFont)
            .foregroundStyle(AppTokens.onAccent)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 52)
            .background(AppTokens.primary.opacity(configuration.isPressed ? 0.82 : 1), in: Capsule())
    }
}

extension View {
    func verdantCard() -> some View {
        self
            .background(AppTokens.surface, in: RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppTokens.radiusCard, style: .continuous)
                    .stroke(AppTokens.hairline, lineWidth: 1)
            }
            .shadow(color: AppTokens.primary.opacity(0.07), radius: 8, y: 2)
    }
}

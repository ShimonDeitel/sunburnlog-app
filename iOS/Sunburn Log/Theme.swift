import SwiftUI

/// Unique visual identity for Sunburn Log: sunburnt coral with cooling teal.
enum Theme {
    static let accent = Color(hex: "#D9784F")
    static let accentSecondary = Color(hex: "#4F8FA6")
    static let background = Color(hex: "#FDF1E9")
    static let ink = Color(hex: "#2A1710")

    static var titleFont: Font {
        Font.system(.largeTitle, design: .default).weight(.bold)
    }

    static var bodyFont: Font {
        Font.system(.body, design: .default)
    }

    static var cardCornerRadius: CGFloat { 18 }
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255.0
        let g = Double((v >> 8) & 0xFF) / 255.0
        let b = Double(v & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

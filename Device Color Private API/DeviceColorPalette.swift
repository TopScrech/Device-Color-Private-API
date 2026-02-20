import SwiftUI

enum DeviceColorPalette {
    static func color(for token: String) -> Color {
        let normalized = token.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if normalized.isEmpty || normalized == "unknown" {
            return Color(uiColor: .systemGray4)
        }
        
        if let hexColor = colorFromHex(normalized) {
            return hexColor
        }
        
        switch normalized {
        case "black", "slate":
            return .black
        case "white", "silver":
            return .white
        case "gray", "grey":
            return .gray
        case "blue":
            return .blue
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "red":
            return .red
        default:
            return Color(uiColor: .systemGray4)
        }
    }
    
    static func foregroundColor(for token: String) -> Color {
        if isDark(token: token) {
            return .white
        }
        return .black
    }
    
    private static func isDark(token: String) -> Bool {
        let normalized = token.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if ["black", "slate", "#3b3b3c", "#99989b"].contains(normalized) {
            return true
        }
        
        guard let rgb = rgbValues(fromHex: normalized) else {
            return false
        }
        
        let relativeLuminance = (0.2126 * rgb.red) + (0.7152 * rgb.green) + (0.0722 * rgb.blue)
        return relativeLuminance < 0.45
    }
    
    private static func colorFromHex(_ token: String) -> Color? {
        guard let rgb = rgbValues(fromHex: token) else {
            return nil
        }
        
        return Color(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }
    
    private static func rgbValues(fromHex token: String) -> (red: Double, green: Double, blue: Double)? {
        let hex = token.replacingOccurrences(of: "#", with: "")
        
        guard hex.count == 6, let value = UInt64(hex, radix: 16) else {
            return nil
        }
        
        let red = Double((value >> 16) & 0xff) / 255
        let green = Double((value >> 8) & 0xff) / 255
        let blue = Double(value & 0xff) / 255
        
        return (red, green, blue)
    }
}

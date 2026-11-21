import Foundation
import SwiftUI
class WidgetSettings {
    static let shared = WidgetSettings()
    private let appGroupId = "group.com.fitodomik.widget"
    private var userDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupId) ?? UserDefaults.standard
    }
    private let userIdKey = "widget_user_id"
    private let themeKey = "widget_theme"
    enum Theme: String, CaseIterable {
        case light = "light"
        case dark = "dark"
        case green = "green"
        var name: String {
            switch self {
            case .light: return "Светлая"
            case .dark: return "Темная"
            case .green: return "Зеленая"
            }
        }
        var colors: ThemeColors {
            switch self {
            case .light:
                return ThemeColors(
                    background: [Color(red: 1.0, green: 1.0, blue: 1.0),
                                Color(red: 0.96, green: 0.96, blue: 0.96)],
                    text: Color.black,
                    cellBackground: Color.white.opacity(0.8),
                    cellBorder: Color.gray.opacity(0.3)
                )
            case .dark:
                return ThemeColors(
                    background: [Color(red: 0.1, green: 0.1, blue: 0.1),
                                Color(red: 0.18, green: 0.18, blue: 0.18)],
                    text: Color.white,
                    cellBackground: Color.white.opacity(0.15),
                    cellBorder: Color.white.opacity(0.2)
                )
            case .green:
                return ThemeColors(
                    background: [Color(red: 0.11, green: 0.37, blue: 0.13),
                                Color(red: 0.18, green: 0.49, blue: 0.20)],
                    text: Color.white,
                    cellBackground: Color.white.opacity(0.15),
                    cellBorder: Color.white.opacity(0.2)
                )
            }
        }
    }
    var userId: Int {
        get {
            let id = userDefaults.integer(forKey: userIdKey)
            return id > 0 ? id : 1
        }
        set {
            userDefaults.set(newValue, forKey: userIdKey)
        }
    }
    var theme: Theme {
        get {
            if let themeString = userDefaults.string(forKey: themeKey),
               let theme = Theme(rawValue: themeString) {
                return theme
            }
            return .green
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: themeKey)
        }
    }
}
struct ThemeColors {
    let background: [Color]
    let text: Color
    let cellBackground: Color
    let cellBorder: Color
}
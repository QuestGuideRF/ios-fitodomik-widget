import SwiftUI
import WidgetKit
struct SettingsView: View {
    @State private var userId: String = ""
    @State private var selectedTheme: WidgetSettings.Theme = .green
    @State private var showingSaveAlert = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Настройки виджета")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("User ID")
                            .font(.headline)
                        TextField("Введите ID пользователя", text: $userId)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Получите ваш User ID на: fitodomik.online/get_token.php")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Тема виджета")
                            .font(.headline)
                        Picker("Тема", selection: $selectedTheme) {
                            ForEach(WidgetSettings.Theme.allCases, id: \.self) { theme in
                                HStack {
                                    themeIcon(for: theme)
                                    Text(theme.name)
                                }
                                .tag(theme)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.vertical, 8)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Предпросмотр")
                            .font(.headline)
                        ThemePreview(theme: selectedTheme)
                            .frame(height: 150)
                            .cornerRadius(12)
                    }
                }
                Section {
                    Button(action: saveSettings) {
                        HStack {
                            Spacer()
                            Text("Сохранить настройки")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
                Section(header: Text("Инструкция")) {
                    VStack(alignment: .leading, spacing: 12) {
                        InstructionStep(number: "1", text: "Откройте fitodomik.online/get_token.php")
                        InstructionStep(number: "2", text: "Скопируйте ваш User ID")
                        InstructionStep(number: "3", text: "Вставьте ID в поле выше")
                        InstructionStep(number: "4", text: "Выберите тему виджета")
                        InstructionStep(number: "5", text: "Нажмите \"Сохранить настройки\"")
                        InstructionStep(number: "6", text: "Долго нажмите на домашний экран → добавьте виджет \"ФитоДомик\"")
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("ФитоДомик 🌱")
            .onAppear {
                loadCurrentSettings()
            }
            .alert("Настройки сохранены!", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Виджет обновится автоматически")
            }
        }
    }
    private func themeIcon(for theme: WidgetSettings.Theme) -> some View {
        switch theme {
        case .light:
            return Text("☀️")
        case .dark:
            return Text("🌙")
        case .green:
            return Text("🌱")
        }
    }
    private func loadCurrentSettings() {
        userId = "\(WidgetSettings.shared.userId)"
        selectedTheme = WidgetSettings.shared.theme
    }
    private func saveSettings() {
        if let id = Int(userId), id > 0 {
            WidgetSettings.shared.userId = id
        } else {
            WidgetSettings.shared.userId = 1
        }
        WidgetSettings.shared.theme = selectedTheme
        WidgetCenter.shared.reloadAllTimelines()
        showingSaveAlert = true
    }
}
struct InstructionStep: View {
    let number: String
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.green)
                .clipShape(Circle())
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            Spacer()
        }
    }
}
struct ThemePreview: View {
    let theme: WidgetSettings.Theme
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: theme.colors.background),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 8) {
                Text("ФитоДомик 🌱")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(theme.colors.text)
                HStack(spacing: 8) {
                    SensorPreviewCell(icon: "🌡️", value: "25°C", colors: theme.colors)
                    SensorPreviewCell(icon: "💧", value: "60%", colors: theme.colors)
                    SensorPreviewCell(icon: "🌱", value: "45%", colors: theme.colors)
                }
            }
            .padding()
        }
    }
}
struct SensorPreviewCell: View {
    let icon: String
    let value: String
    let colors: ThemeColors
    var body: some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.system(size: 20))
            Text(value)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(colors.text)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colors.cellBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(colors.cellBorder, lineWidth: 1)
        )
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
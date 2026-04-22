import SwiftUI
import WidgetKit
struct FarmWidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    private var themeColors: ThemeColors {
        WidgetSettings.shared.theme.colors
    }
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: themeColors.background),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 4) {
                Text("ФитоДомик 🌱")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(themeColors.text)
                Text(entry.sensorData.updateTime)
                    .font(.system(size: 9))
                    .foregroundColor(themeColors.text.opacity(0.7))
                Spacer(minLength: 2)
                switch widgetFamily {
                case .systemSmall:
                    smallWidgetContent
                case .systemMedium:
                    mediumWidgetContent
                case .systemLarge:
                    largeWidgetContent
                default:
                    smallWidgetContent
                }
                Spacer(minLength: 2)
            }
            .padding(8)
        }
    }
    var smallWidgetContent: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                SensorCell(icon: "🌡️", value: entry.sensorData.temperature, colors: themeColors)
                SensorCell(icon: "💧", value: entry.sensorData.humidity, colors: themeColors)
            }
            HStack(spacing: 4) {
                SensorCell(icon: "🌱", value: entry.sensorData.soilMoisture, colors: themeColors)
                SensorCell(icon: "🌍", value: entry.sensorData.co2, fontSize: 9, colors: themeColors)
            }
            HStack(spacing: 4) {
                SensorCell(icon: "🌬️", value: entry.sensorData.pressure, fontSize: 9, colors: themeColors)
                SensorCell(icon: "🚪", value: entry.sensorData.curtains, fontSize: 9, colors: themeColors)
            }
            HStack(spacing: 4) {
                SensorCell(icon: "💡", value: entry.sensorData.lamp, fontSize: 9, colors: themeColors)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    var mediumWidgetContent: some View {
        HStack(spacing: 6) {
            VStack(spacing: 4) {
                SensorCell(icon: "🌡️", value: entry.sensorData.temperature, colors: themeColors)
                SensorCell(icon: "🌱", value: entry.sensorData.soilMoisture, colors: themeColors)
            }
            VStack(spacing: 4) {
                SensorCell(icon: "💧", value: entry.sensorData.humidity, colors: themeColors)
                SensorCell(icon: "🌍", value: entry.sensorData.co2, fontSize: 9, colors: themeColors)
            }
            VStack(spacing: 4) {
                SensorCell(icon: "🌬️", value: entry.sensorData.pressure, fontSize: 9, colors: themeColors)
                SensorCell(icon: "🚪", value: entry.sensorData.curtains, fontSize: 9, colors: themeColors)
            }
            VStack(spacing: 4) {
                SensorCell(icon: "💡", value: entry.sensorData.lamp, fontSize: 9, colors: themeColors)
                    .frame(maxHeight: .infinity)
            }
        }
    }
    var largeWidgetContent: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                SensorCell(icon: "🌡️", value: entry.sensorData.temperature, fontSize: 12, colors: themeColors)
                SensorCell(icon: "💧", value: entry.sensorData.humidity, fontSize: 12, colors: themeColors)
            }
            HStack(spacing: 6) {
                SensorCell(icon: "🌱", value: entry.sensorData.soilMoisture, fontSize: 12, colors: themeColors)
                SensorCell(icon: "🌍", value: entry.sensorData.co2, fontSize: 11, colors: themeColors)
            }
            HStack(spacing: 6) {
                SensorCell(icon: "🌬️", value: entry.sensorData.pressure, fontSize: 11, colors: themeColors)
                SensorCell(icon: "🚪", value: entry.sensorData.curtains, fontSize: 11, colors: themeColors)
            }
            HStack(spacing: 6) {
                SensorCell(icon: "💡", value: entry.sensorData.lamp, fontSize: 11, colors: themeColors)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
struct SensorCell: View {
    let icon: String
    let value: String
    var fontSize: CGFloat = 10
    let colors: ThemeColors
    var body: some View {
        VStack(spacing: 2) {
            Text(icon)
                .font(.system(size: fontSize + 4))
            Text(value)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(colors.text)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(colors.cellBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(colors.cellBorder, lineWidth: 1)
        )
    }
}
struct FarmWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = CachedSensorData(
            temperature: "25.0°C",
            humidity: "60.0%",
            soilMoisture: "45.0%",
            co2: "450 ppm",
            pressure: "760.0",
            curtains: "Откр",
            lamp: "Вкл",
            updateTime: "14:30"
        )
        let entry = SimpleEntry(date: Date(), sensorData: sampleData)
        Group {
            FarmWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small Widget - Green")
            FarmWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium Widget - Green")
        }
    }
}
import WidgetKit
import SwiftUI
@main
struct FitoDomikWidget: Widget {
    let kind: String = "FitoDomikWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FarmWidgetView(entry: entry)
        }
        .configurationDisplayName("ФитоДомик")
        .description("Отображает текущее состояние вашей умной фермы.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
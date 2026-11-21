import WidgetKit
import SwiftUI
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), sensorData: CachedSensorData.placeholder)
    }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let cachedData = ApiService.loadCachedData()
        let entry = SimpleEntry(date: Date(), sensorData: cachedData)
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("🔄 Получение графика...")
        ApiService.fetchSensorData { result in
            let currentDate = Date()
            let entry: SimpleEntry
            switch result {
            case .success(let data):
                print("✅ Данные успешно получены.")
                ApiService.saveSensorData(data)
                let cachedData = ApiService.loadCachedData()
                entry = SimpleEntry(date: currentDate, sensorData: cachedData)
            case .failure(let error):
                print("❌ Не удалось получить данные: \(error.localizedDescription).")
                let cachedData = ApiService.loadCachedData()
                entry = SimpleEntry(date: currentDate, sensorData: cachedData)
            }
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            print("⏰ Следующее обновление запланировано на: \(nextUpdate)")
            completion(timeline)
        }
    }
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let sensorData: CachedSensorData
}
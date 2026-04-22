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
        print("🔄 Getting timeline...")
        ApiService.fetchSensorData { result in
            let currentDate = Date()
            let entry: SimpleEntry
            switch result {
            case .success(let data):
                print("✅ Successfully fetched data")
                ApiService.saveSensorData(data)
                let cachedData = ApiService.loadCachedData()
                entry = SimpleEntry(date: currentDate, sensorData: cachedData)
            case .failure(let error):
                print("❌ Failed to fetch data: \(error.localizedDescription)")
                let cachedData = ApiService.loadCachedData()
                entry = SimpleEntry(date: currentDate, sensorData: cachedData)
            }
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            print("⏰ Next update scheduled for: \(nextUpdate)")
            completion(timeline)
        }
    }
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let sensorData: CachedSensorData
}
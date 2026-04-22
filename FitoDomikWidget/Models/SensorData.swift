import Foundation
struct ApiResponse: Codable {
    let ok: Bool
    let data: SensorDataContainer?
    let updatedAt: String?
    let timestamp: Int?
    enum CodingKeys: String, CodingKey {
        case ok
        case data
        case updatedAt = "updated_at"
        case timestamp
    }
}
struct SensorDataContainer: Codable {
    let temperature: SensorValue
    let humidity: SensorValue
    let soilMoisture: SensorValue
    let co2: SensorValue
    let pressure: SensorValue
    let curtains: StateValue
    let lamp: StateValue
    enum CodingKeys: String, CodingKey {
        case temperature
        case humidity
        case soilMoisture = "soil_moisture"
        case co2
        case pressure
        case curtains
        case lamp
    }
}
struct SensorValue: Codable {
    let value: String
    let unit: String
    let icon: String
}
struct StateValue: Codable {
    let value: String
    let state: Int
    let icon: String
}
struct CachedSensorData: Codable {
    let temperature: String
    let humidity: String
    let soilMoisture: String
    let co2: String
    let pressure: String
    let curtains: String
    let lamp: String
    let updateTime: String
    static var placeholder: CachedSensorData {
        CachedSensorData(
            temperature: "--°C",
            humidity: "--%",
            soilMoisture: "--%",
            co2: "-- ppm",
            pressure: "--",
            curtains: "--",
            lamp: "--",
            updateTime: "--:--"
        )
    }
}
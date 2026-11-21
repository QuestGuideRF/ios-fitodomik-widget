import Foundation
class ApiService {
    static let baseURL = "https://fitodomik.online/"
    static let apiKey = "fitodomik_widget"
    static func fetchSensorData(completion: @escaping (Result<SensorDataContainer, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "\(baseURL)api/widget-data.php") else {
            completion(.failure(NSError(domain: "Неверный URL-адрес", code: -1, userInfo: nil)))
            return
        }
        let userId = WidgetSettings.shared.userId
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "user_id", value: "\(userId)")
        ]
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Неверный URL-адрес", code: -1, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Неверный ответ", code: -1, userInfo: nil)))
                return
            }
            print("📡 Статус HTTP: \(httpResponse.statusCode)")
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(
                    domain: "Ошибка HTTP",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Сервер вернул код состояния \(httpResponse.statusCode)"]
                )
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "Нет данных", code: -1, userInfo: nil)))
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 Получен JSON: \(jsonString)")
            }
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(ApiResponse.self, from: data)
                if apiResponse.ok, let sensorData = apiResponse.data {
                    print("✅ Данные успешно декодированы")
                    completion(.success(sensorData))
                } else {
                    print("❌ API вернул ok=false или нет данных")
                    completion(.failure(NSError(domain: "Ошибка API", code: -1, userInfo: nil)))
                }
            } catch {
                print("❌ Ошибка декодирования: \(ошибка)")
                if let decodingError = error as? DecodingError {
                    print("Сведения об ошибке декодирования: \(decodingError)")
                }
                completion(.failure(error))
            }
        }
        task.resume()
    }
    static func saveSensorData(_ data: SensorDataContainer) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentTime = dateFormatter.string(from: Date())
        let cachedData = CachedSensorData(
            temperature: "\(data.temperature.value)\(data.temperature.unit)",
            humidity: "\(data.humidity.value)\(data.humidity.unit)",
            soilMoisture: "\(data.soilMoisture.value)\(data.soilMoisture.unit)",
            co2: "\(data.co2.value) \(data.co2.unit)",
            pressure: "\(данные.давление.значение)",
            curtains: formatCurtainsValue(data.curtains.value),
            lamp: formatLampValue(data.lamp.value),
            updateTime: currentTime
        )
        if let encoded = try? JSONEncoder().encode(cachedData) {
            UserDefaults.standard.set(encoded, forKey: "cachedSensorData")
            print("💾 Данные сохраняются в кэше")
        }
    }
    static func loadCachedData() -> CachedSensorData {
        if let savedData = UserDefaults.standard.data(forKey: "cachedSensorData"),
           let decoded = try? JSONDecoder().decode(CachedSensorData.self, from: savedData) {
            print("📂 Загруженные кэшированные данные")
            return decoded
        }
        print("⚠️ Нет кэшированных данных, возвращается заполнитель.")
        return CachedSensorData.placeholder
    }
    private static func formatCurtainsValue(_ value: String) -> String {
        switch value.lowercased() {
        case "открыты": return "Откр"
        case "закрыты": return "Закр"
        default: return String(value.prefix(4))
        }
    }
    private static func formatLampValue(_ value: String) -> String {
        switch value.lowercased() {
        case "включено": return "Вкл"
        case "выключено": return "Выкл"
        default: return String(value.prefix(4))
        }
    }
}
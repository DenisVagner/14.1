
import Foundation


struct MainResponce: Decodable {
    var weather: [WeatherInfo]
    var main: MainInfo
    var wind: WindInfo
}

struct WeatherInfo: Decodable {
    var id: Int
    var main: String
    var description: String
}

struct MainInfo: Decodable {
    var temp: Double
    var feels_like: Double?
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
}

struct WindInfo: Decodable {
    var speed: Double
}

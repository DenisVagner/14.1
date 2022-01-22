
import Foundation


struct MainResponce: Decodable {
    var weather: [WeatherInfo]
    var main: MainInfo
}

struct WeatherInfo: Decodable {
    var id: Int
    var main: String
    var description: String
}

struct MainInfo: Decodable {
    var temp: Double
    var feels_like: Double
    var pressure: Double
}


import Foundation

struct SearchingCity: Decodable {
    var name: String?
    var local_names: LocalNames?
    var country: String?
    var state: String?
}

struct LocalNames: Decodable {
    var ru: String?
    var en: String?
}

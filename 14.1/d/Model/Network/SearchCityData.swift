
import Foundation

struct SearchingCity1: Decodable {
    var name: String?
    var local_names: LocalNames1?
    var country: String?
    var state: String?
}

struct LocalNames1: Decodable {
    var ru: String?
    var en: String?
}


import Foundation

class Base{
    let defaults = UserDefaults.standard
    static let shared = Base()
    
    private let aUserFirstNameKey = "FullName.aUserFirstNameKey"
    private let aUserSecondNameKey = "FullName.aUserSecondNameKey"
    
    struct FullName: Codable {
        var firstName: String
        var secondName: String
    }
    
    var fullNames: [FullName] {
        get {
            if let data = defaults.value(forKey: "fullNames") as? Data {
                return try! PropertyListDecoder().decode([FullName].self, from: data)
            } else {
                return [FullName]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "fullNames")
            }
        }
    }
    
    func saveFullName(firstName: String, secondName: String) {
        let names = FullName(firstName: firstName, secondName: secondName)
        fullNames.append(names)
    }
}

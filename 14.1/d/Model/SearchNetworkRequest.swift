
import Foundation
import Alamofire

class SearchRequest {
    func doSearchRequest (urlString: String, completion: @escaping ([SearchingCity1?]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("some error, check you internet connection")
                    completion(nil, error)
                    return
                }
                guard let data = data else { return }
                do {
                    let cities = try JSONDecoder().decode([SearchingCity1?].self, from: data)
                    completion(cities, nil)
                    
                } catch let jsonError {
                    print("FILED TO DECODE JSON", jsonError)
                    completion(nil, jsonError)
                }
                //let someData = String(data: data, encoding: .utf8)
                // print(someData ?? "no data")
            }
        }.resume()
    }
}

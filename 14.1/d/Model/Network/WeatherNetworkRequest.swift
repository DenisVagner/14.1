
import Foundation
import Alamofire

class WeatherNetworkRequest {
    let myGroup = DispatchGroup()
    func doRequest (urlString: String, completion: @escaping (Result<MainResponce, Error>) -> Void) {
        
        
            AF.request(urlString).responseJSON { response in
                guard let data = response.data else {
                    print("cant load data from network")
                    return
                }
                do {
                    let res = try JSONDecoder().decode(MainResponce.self, from: data)
                   // DispatchQueue.main.async {
                        print("network request success")
                        completion(.success(res))
                    
                  //  }
                } catch let jsonError {
                    print("error parsing json", jsonError)
                    completion(.failure(jsonError))
                }
            }
        
    }
}

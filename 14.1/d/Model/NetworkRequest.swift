
import Foundation
import Alamofire

class NetworkRequest {
    func doRequest (urlString: String, completion: @escaping (Result<MainResponce, Error>) -> Void) {
        AF.request(urlString).responseJSON { response in
            guard let data = response.data else {
                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                return
            }
            do {
                let res = try JSONDecoder().decode(MainResponce.self, from: data)
                DispatchQueue.main.async {
                    print("network request secsess")
                    completion(.success(res))
                }
            } catch let jsonError {
                print("ERROR!!!", jsonError)
                completion(.failure(jsonError))
            }
        }
    
    }
}

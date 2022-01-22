
import UIKit

class DetailInfoViewController: UIViewController {
    
    var currentCity = "no city"
    var resultOneCity: MainResponce? = nil
    var urlString: String {
        get {
            "https://api.openweathermap.org/data/2.5/weather?q=\(currentCity)&appid=12208d4516ef042a2be4ddbfd1d9695d"
        }
    }
    let networkRequest = NetworkRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityInfoFromNetwork()
        
    }
    
    // запрос данных по нажатому городу
    func loadCityInfoFromNetwork() {
        //activityIndicator.isHidden = false
        networkRequest.doRequest(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let cityInfo):
                self?.resultOneCity = cityInfo
                print(cityInfo.main.temp - 273)
                //self?.setLabels()
            case .failure(let error):
                print(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

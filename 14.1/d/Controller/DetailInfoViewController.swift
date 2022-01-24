
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
    
    
    // Labels
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var hamidityLabel: UILabel!
    
    
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
                //print(cityInfo.main.temp - 273)
                self?.setLabels()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Заполнение полей
    func setLabels() {
        cityNameLabel.text = currentCity
        currentTempLabel.text = "\(Int((resultOneCity?.main.temp ?? 273) - 273)) º"
        descriptionLabel.text = resultOneCity?.weather[0].description
        feelsLikeLabel.text = "\(Int((resultOneCity?.main.feels_like ?? 0) - 273)) º"
        minTempLabel.text = "\(Int((resultOneCity?.main.temp_min ?? 0) - 273)) º"
        maxTempLabel.text = "\(Int((resultOneCity?.main.temp_max ?? 0) - 273)) º"
        windSpeedLabel.text = "\(Int(resultOneCity?.wind.speed ?? 0)) м/с"
        hamidityLabel.text = "\(Int(resultOneCity?.main.humidity ?? 0)) %"
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

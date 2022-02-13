
import UIKit
import CoreData

class DetailInfoViewController: UIViewController {
    
    var currentCity = "no city"
    var resultOneCity: MainResponce? = nil
    var urlString: String {
        get {
            "https://api.openweathermap.org/data/2.5/weather?q=\(currentCity)&appid=12208d4516ef042a2be4ddbfd1d9695d"
        }
    }
    let networkRequest = WeatherNetworkRequest()
    
    
    // Labels
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var hamidityLabel: UILabel!
    
    @IBOutlet weak var activIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        print("Labels sets from database")
        loadCityInfoFromNetwork()
        
    }
    
    // запрос данных по нажатому городу
    func loadCityInfoFromNetwork() {
        activIndicator.startAnimating()
        networkRequest.doRequest(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let cityInfo):
                self?.resultOneCity = cityInfo
                sleep(3)
                print("Data recived")
                self?.setValuesSearchingCity()
                self?.setLabels()
                self?.activIndicator.stopAnimating()
            case .failure(let error):
                print(error)
                self?.activIndicator.stopAnimating()
            }
        }
    }
    
    //MARK: Установка значения атрибутов
    func setValuesSearchingCity (){
        let managedObjectOneCityInfo = OneCityInfo()
        managedObjectOneCityInfo.city_name = currentCity
        managedObjectOneCityInfo.temp = "\(Int((resultOneCity?.main.temp ?? 273) - 273)) º"
        managedObjectOneCityInfo.temp_min = "\(Int((resultOneCity?.main.temp_min ?? 0) - 273)) º"
        managedObjectOneCityInfo.temp_max = "\(Int((resultOneCity?.main.temp_max ?? 0) - 273)) º"
        managedObjectOneCityInfo.feels_like = "\(Int((resultOneCity?.main.feels_like ?? 0) - 273)) º"
        managedObjectOneCityInfo.wind_speed = "\(Int(resultOneCity?.wind.speed ?? 0)) м/с"
        managedObjectOneCityInfo.humidity = "\(Int(resultOneCity?.main.humidity ?? 0)) %"
        managedObjectOneCityInfo.main_description = resultOneCity?.weather[0].description
        // Запись объекта
        CoreDataManager.instance.saveContext()
        print("Data saved OneCityInfo")
    }
    
    // Извлечение записей
    func getDataOneCityInfo() -> [NSFetchRequestResult] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OneCityInfo")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            return results
        }catch {
            print(error)
            return []
        }
    }
    
    
    // MARK: - Заполнение полей
    func setLabels() {
        let cityInfoArray = getDataOneCityInfo()
        for cityInfo in cityInfoArray as! [NSManagedObject] {
            if let cityName = cityInfo.value(forKey: "city_name") as? String {
                if cityName == currentCity {
                    cityNameLabel.text = cityInfo.value(forKey: "city_name") as? String
                    currentTempLabel.text = cityInfo.value(forKey: "temp") as? String
                    descriptionLabel.text = cityInfo.value(forKey: "main_description") as? String
                    feelsLikeLabel.text = cityInfo.value(forKey: "feels_like") as? String
                    minTempLabel.text = cityInfo.value(forKey: "temp_min") as? String
                    maxTempLabel.text = cityInfo.value(forKey: "temp_max") as? String
                    windSpeedLabel.text = cityInfo.value(forKey: "wind_speed") as? String
                    hamidityLabel.text = cityInfo.value(forKey: "humidity") as? String
                }
            }
        }
        print("Labels sets")
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

//d) Сделать экран с показом погоды. Сделайте кеширование для текущей погоды и прогноза после загрузки с сервера, чтобы после перезапуска показывались последние сохранённые данные (пока идёт повторное обновление).

import UIKit
import CoreData

class CitiesViewController: UIViewController {
    @IBOutlet weak var citiesInFavoriteTableView: UITableView!
    @IBOutlet weak var citiesTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    var currentCity = ""
    var result: MainResponce? = nil
    let networkRequest = WeatherNetworkRequest()
    
    //Переменная для обновления таблицы 1 раз после получения данных о погоде по каждому городу
    var tmpCount = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateData()
    tmpCount = 0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.citiesInFavoriteTableView.reloadData()
        print("table reloaded from viewDidAppear")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    let myGroup = DispatchGroup()
    
    
//MARK: - Refresh button pressed
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateData()
    }
    
    
    func updateData() {
        activityInd.startAnimating()
        updateTempCitiesInFavorite()
    }
    
    
    
    // Обновление данных о текущей погоде для городов в избранном
    func updateTempCitiesInFavorite() {
        let citiesData = self.getDataCitiesInFavorite()
        for city in citiesData as! [NSManagedObject] {
                self.networkRequest.doRequest(urlString: "https://api.openweathermap.org/data/2.5/weather?q=\(city.value(forKey: "name_en") ?? "")&appid=12208d4516ef042a2be4ddbfd1d9695d") { result in
                    switch result {
                    case .success(let cityInfo):
                        city.setValue(String(Int(cityInfo.main.temp - 273)), forKey: "cur_temp")
                        CoreDataManager.instance.saveContext()
                        print("Context saved (temp): ", Int(cityInfo.main.temp - 273))
                        self.tmpCount += 1
                        print(self.tmpCount)
                        if self.tmpCount == citiesData.count {
                            self.citiesInFavoriteTableView.reloadData()
                            print("Table reloaded from updateTempCitiesInFavorite")
                            self.activityInd.stopAnimating()
                            self.tmpCount = 0
                        }
                        
                    case .failure(let error):
                        //cell1.curTempInFavLabel.text = "--"
                        print(error)
                    }
                }
           // }
            
            
        }
    }
    
    
    // Передача названия нажатого города на следующий экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = citiesInFavoriteTableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailInfoViewController, segue.identifier == "CityInfo" {
                let cityData = getDataCitiesInFavorite()
                let object1 = cityData[index.row] as! NSManagedObject
                vc.currentCity = object1.value(forKey: "name_en") as! String
            }
        }
        
        
        //        if segue.identifier == "CityInfo" {
        //            if let indexPath = citiesInFavoriteTableView.indexPathForSelectedRow {
        //                let restaurant: Restaurant
        //                if isFiltering {
        //                    restaurant = filtredRestaurant[indexPath.row]
        //                } else {
        //                    restaurant = Restaurant[indexPath.row]
        //                }
        //                let vc = segue.destination as! DetailInfoViewController
        //                vc.restaurant = restaurant
        //            }
        //        }
    }
    
    // Извлечение записей
    func getDataCitiesInFavorite() -> [NSFetchRequestResult] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInFavorite")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            return results
        }catch {
            print(error)
            return []
        }
    }
}

// MARK: - TableView setup
extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countOfCities = getDataCitiesInFavorite()
        return countOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        let citiesData = getDataCitiesInFavorite()
        let object1 = citiesData[indexPath.row] as! NSManagedObject
        cell1.cityNameLabel.text = object1.value(forKey: "name_en") as? String
        cell1.curTempInFavLabel.text = object1.value(forKey: "cur_temp") as? String
        return cell1
    }
    
    // Убирает выделение ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Удаление ячейки по свайпу
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let result = getDataCitiesInFavorite()
            let object1 = result[indexPath.row] as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(object1)
            CoreDataManager.instance.saveContext()
            print("Data saved after deleting row")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}








// Add button - добавить новый город
//    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
//
//        let alertController = UIAlertController(title: "Добавить город", message: "Введите название города", preferredStyle: .alert)
//        alertController.addTextField()
//        let addAction = UIAlertAction(title: "Добавить", style: .default) { action in
//            let tf = alertController.textFields?.first
//
//
//            if tf?.text != "" {
//                self.citiesInFavoriteArray.append(tf?.text)
//                self.citiesInFavoriteTableView.reloadData()
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//        alertController.addAction(addAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//
//    }

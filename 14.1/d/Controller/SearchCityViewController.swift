
import UIKit
import CoreData

class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var foundedCities: [SearchingCity1] = []
    let networkRequest = SearchRequest()
    var searchingText = ""
    var urlString: String {
        get {
            "https://api.openweathermap.org/geo/1.0/direct?q=\(String(searchingText.utf8))&limit=5&appid=12208d4516ef042a2be4ddbfd1d9695d"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // Отправка интернет запроса для поиска введенного города
    func searchRequest() {
        networkRequest.doSearchRequest(urlString: urlString) { searchingCity, error in
            if let error = error {
                print(error)
                return
            }
            self.foundedCities = searchingCity as! [SearchingCity1]
            self.searchTableView.reloadData()
        }
    }
    
    
    // Установка значения атрибута
    func setNamesSearchingCity (name_en: String, name_ru: String?){
        let managedObjectCitiesInFavorite = CitiesInFavorite()
        managedObjectCitiesInFavorite.name_en = name_en
        managedObjectCitiesInFavorite.name_ru = name_ru
        // Запись объекта
        CoreDataManager.instance.saveContext()
        print("Data saved CitiesInFavorite")
    }
    
    
    // Извлечение записей
    func getData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInFavorite")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) //(fetchRequest) //self.managedObjectContext.execute(fetchRequest)
            
            //            for result in results as! [NSManagedObject] {
            //                print("name = \(result.value(forKey: "name_en") ?? "")")
            //            }
        } catch {
            print(error)
        }
    }
}

// MARK: - Table setup
extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        if let ru_name = foundedCities[indexPath.row].local_names?.ru {// != nil {
            cell.searchCityTextLabel.text = "\(ru_name)"
            
        } else if let en_name = foundedCities[indexPath.row].name{
            cell.searchCityTextLabel.text = "\(en_name)"
        }
        cell.searchLocationTextLabel.text = "\(foundedCities[indexPath.row].country ?? "--"), \(foundedCities[indexPath.row].state ?? "--")"
        return cell
        
    }
    
    // Действия при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // let cell = searchTableView.cellForRow(at: indexPath) as! SearchTableViewCell
        setNamesSearchingCity(name_en: foundedCities[indexPath.row].name!, name_ru: foundedCities[indexPath.row].local_names?.ru)
    }
}

// MARK: - SearchBar setup
extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            foundedCities = []
            searchTableView.reloadData()
            return
        }
        self.searchingText = searchText
        searchRequest()
    }
}











//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn ) {
//            self.citiesInFavoriteTableView.frame.origin.y = self.searchTableView.frame.size.height
//        }
//        return true
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn ) {
//            self.citiesInFavoriteTableView.frame.origin.y -= 100 //self.searchTableView.frame.size.height
//        }
//    }
//
//}

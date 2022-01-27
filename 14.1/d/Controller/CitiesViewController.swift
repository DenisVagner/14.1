//d) Сделать экран с показом погоды. Сделайте кеширование для текущей погоды и прогноза после загрузки с сервера, чтобы после перезапуска показывались последние сохранённые данные (пока идёт повторное обновление).

import UIKit
import SwiftUI

class CitiesViewController: UIViewController {
    @IBOutlet weak var citiesInFavoriteTableView: UITableView!
    @IBOutlet weak var citiesTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchController = UISearchController()
    
    var citiesInFavoriteArray: [String?] = ["London", "Moscow", "Ankara", "Mexico", "1"]
    var foundedCities: [String?] = []
    var currentCity = ""
    var result: MainResponce? = nil
    var urlString: String {
        get {
            "https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=12208d4516ef042a2be4ddbfd1d9695d"
        }
    }
    let networkRequest = NetworkRequest()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // setupSearchController()
        citiesInFavoriteTableView.reloadData()
       // self.citiesInFavoriteTableView.frame.origin.y = 200
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=paris&limit=7&appid=12208d4516ef042a2be4ddbfd1d9695d"
        searchRequest(urlString: urlString) { searchingCity, error in
            for i  in 0...((searchingCity?.count)! - 1) {
                if searchingCity![i]?.local_names?.ru == nil {
                    print(searchingCity![i]?.name, ", ", searchingCity![i]?.state, ", ", searchingCity![i]?.country)
                    continue
                }
                print(searchingCity?[i]!.local_names?.ru, ", ", searchingCity![i]?.state, ", ", searchingCity![i]?.country)
               // print(searchingCity?[i]!.local_names?.ru != nil ? searchingCity?[i]?.local_names?.ru : searchingCity?[i]?.local_names?.en!)
            }
            
        }

    }
    
    func searchRequest (urlString: String, completion: @escaping ([SearchingCity?]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("some error")
                    completion(nil, error)
                    return
                }
                guard let data = data else { return }
                do {
                    let cities = try JSONDecoder().decode([SearchingCity?].self, from: data)
                    completion(cities, nil)
                    
                } catch let jsonError {
                    print("FILED TO DECODE JSON", jsonError)
                    completion(nil, jsonError)
                }
                let someData = String(data: data, encoding: .utf8)
               // print(someData ?? "no data")
            }
        }.resume()
    }
//    func setupSearchController() {
//        navigationItem.searchController = searchController
//        searchController.searchBar.delegate = self
//    }
    
    
    // MARK: - Add button
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
    
    
    // Передача названия нажатого города на следующий экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        
        
        if let cell = sender as? UITableViewCell, let index = citiesInFavoriteTableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailInfoViewController, segue.identifier == "CityInfo" {
                vc.currentCity = (citiesInFavoriteArray[index.row] ?? "")
            }
        }
    }
}

// MARK: - TableView setup
extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return citiesInFavoriteArray.count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
                cell1.cityNameLabel.text = self.citiesInFavoriteArray[indexPath.row]
                self.networkRequest.doRequest(urlString: "https://api.openweathermap.org/data/2.5/weather?q=\(self.citiesInFavoriteArray[indexPath.row] ?? "")&appid=12208d4516ef042a2be4ddbfd1d9695d") { result in
                    switch result {
                    case .success(let cityInfo):
                        cell1.curTempInFavLabel.text = "\(Int(cityInfo.main.temp - 273)) º"
                    case .failure(let error):
                        cell1.curTempInFavLabel.text = "--"
                        print(error)
                    }
                }
        return cell1
    }
    
    // Убирает выделение ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            citiesInFavoriteArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

// MARK: - SearchBar setup
//extension CitiesViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//    }
//
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
//
//extension CitiesViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        findContentInSearchedText(searchController.searchBar.text!)
//    }
//    func findContentInSearchedText (_ searchText: String) {
//        foundedCities = citiesInFavoriteArray.filter({ _ -> Bool in
//            return citiesInFavoriteArray.contains(searchText.lowercased())
//        })
//    }
//
//}
//

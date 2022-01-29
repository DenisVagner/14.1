
import UIKit

class SearchCityViewController: UIViewController {
    var foundedCities: [SearchingCity] = []
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController()
    let networkRequest = SearchRequest()
    var searchingText = ""
    var urlString: String {
        get {
            "https://api.openweathermap.org/geo/1.0/direct?q=\(searchingText)&limit=7&appid=12208d4516ef042a2be4ddbfd1d9695d"
            
        }
    }
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        
        // setupSearchController()
        
    }
    
    func searchRequest() {
        networkRequest.doSearchRequest(urlString: urlString) { searchingCity, error in
            if let error = error {
                print(error)
                return
            }
            self.foundedCities = searchingCity as! [SearchingCity]
            self.searchTableView.reloadData()
        }
    }
    //        func setupSearchController() {
    //            navigationItem.searchController = searchController
    //            searchController.searchBar.delegate = self
    //        }

}

// MARK: - Table setup
extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        if let ru_name = foundedCities[indexPath.row].local_names?.ru {// != nil {
            cell.searchTextLabel.text = "\(ru_name), \(foundedCities[indexPath.row].country ?? "--"), \(foundedCities[indexPath.row].state ?? "--")"
        } else if let en_name = foundedCities[indexPath.row].name{
            cell.searchTextLabel.text = "\(en_name), \(foundedCities[indexPath.row].country ?? "--"), \(foundedCities[indexPath.row].state ?? "--")"
        }
        return cell
        
    }
    
    
}

// MARK: - SearchBar setup
extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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

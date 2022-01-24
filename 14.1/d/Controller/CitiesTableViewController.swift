//d) Сделать экран с показом погоды. Сделайте кеширование для текущей погоды и прогноза после загрузки с сервера, чтобы после перезапуска показывались последние сохранённые данные (пока идёт повторное обновление).

import UIKit

class CitiesTableViewController: UITableViewController {
    @IBOutlet var cityTableView: UITableView!
    
    var citiesInFavoriteArray: [String?] = ["London", "Moscow", "Ankara", "Mexico", "no city"]
    var currentCity = ""
    var result: MainResponce? = nil
    var urlString: String {
        get {
            "https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=12208d4516ef042a2be4ddbfd1d9695d"
        }
    }
    let networkRequest = NetworkRequest()
    
    
    // запрос данных по нажатому городу
    func loadCityInfoFromNetwork() {
        //activityIndicator.isHidden = false
        networkRequest.doRequest(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let cityInfo):
                self?.result = cityInfo
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Добавить город", message: "Введите название города", preferredStyle: .alert)
        alertController.addTextField()
        let addAction = UIAlertAction(title: "Добавить", style: .default) { action in
            let tf = alertController.textFields?.first
            if tf?.text != "" {
                self.citiesInFavoriteArray.append(tf?.text)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    

    // MARK: - Table view data source
    
    // Передача названия нажатого города на следующий экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = cityTableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailInfoViewController, segue.identifier == "CityInfo" {
                vc.currentCity = (citiesInFavoriteArray[index.row] ?? "")
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citiesInFavoriteArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        
        cell.cityNameLabel.text = citiesInFavoriteArray[indexPath.row]
        
        
        networkRequest.doRequest(urlString: "https://api.openweathermap.org/data/2.5/weather?q=\(cell.cityNameLabel.text ?? "Moscow")&appid=12208d4516ef042a2be4ddbfd1d9695d") { result in
                switch result {
                case .success(let cityInfo):
                    cell.curTempInFavLabel.text = "\(Int(cityInfo.main.temp - 273)) º"
                case .failure(let error):
                    print(error)
                }
            }
        
            

        return cell
    }
    
    // Убирает выделение ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            citiesInFavoriteArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

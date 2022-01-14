// b) Список Todo с возможностью добавления и удаления задач, в котором задачи кешируются в Realm, а при повторном запуске показываются последние сохранённые задачи.

import UIKit
import RealmSwift


class bViewController: UIViewController {
    
    @IBOutlet weak var taskInputTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let realm =  try! Realm()
    var tasks: Results<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = realm.objects(TaskList.self)
    }
    
    // Запись задачи в базу данных по нажатию +
    @IBAction func addButtonPressed(_ sender: Any) {
        if taskInputTextField.text != "" {
            let task = TaskList()
            task.task = taskInputTextField.text!
            try! realm.write({
                realm.add(task)
            })
            
            taskInputTextField.text = ""
            tableView.reloadData()
        }
    }
}

extension bViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count > 0 ? tasks.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as! ListTableViewCell
        cell.taskLabel.text = tasks[indexPath.row].task
        return cell
    }
    
    // Убирает выделение ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
        // Удаление ячейки по свайпу влево
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingRow = tasks[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            try! self.realm.write({
                self.realm.delete(editingRow)
                tableView.reloadData()
            })
            complete(true)
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
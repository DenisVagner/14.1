// a) два текстовых поля для имени и фамилии, которые сохраняют введённые данные в UserDefaults, а при повторном запуске приложения показывают последние введённые строки;

import UIKit

class aViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextfield: UITextField!
    @IBOutlet weak var addDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Base.shared.fullNames.isEmpty{
            firstNameTextField.text = Base.shared.fullNames[Base.shared.fullNames.count - 1].firstName
            secondNameTextfield.text = Base.shared.fullNames[Base.shared.fullNames.count - 1].secondName
        }
    }
    @IBAction func addData(_ sender: Any) {
        Base.shared.saveFullName(firstName: firstNameTextField.text ?? "", secondName: secondNameTextfield.text ?? "")
        firstNameTextField.text = ""
        secondNameTextfield.text = ""
    }
}




import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet  weak var searchCityTextLabel: UILabel!
    @IBOutlet weak var searchLocationTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  cTableViewCell.swift
//  14.1
//
//  Created by Денис Вагнер on 19.01.2022.
//

import UIKit

class CTableViewCell: UITableViewCell {

    @IBOutlet weak var cTaskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

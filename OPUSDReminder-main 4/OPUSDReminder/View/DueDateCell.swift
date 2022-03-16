//
//  DueDateCell.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/5/21.
//

import UIKit

class DueDateCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

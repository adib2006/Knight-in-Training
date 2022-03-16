//
//  FooterCell.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/10/22.
//

import UIKit

class FooterCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var tableView: UITableView?
    weak var vc: ClassworkVC?
    var `class`: Class!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func loadOlderBtnPressed(_ sender: UIButton) {
        spinner.startAnimating()
        Classroom.singleton.addNextAssignments(toClass: `class`) { [weak self] in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.tableView?.reloadData()
                self?.vc?.updateNumMissingAssignmentsBadge()
            }
        }
    }
}

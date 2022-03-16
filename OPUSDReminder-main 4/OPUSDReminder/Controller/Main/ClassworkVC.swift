//
//  ClassworkVC.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/3/21.
//

import UIKit
import GoogleSignIn

class ClassworkVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var missingCircle: UIImageView!
    @IBOutlet weak var numMissingLabel: UILabel!
    
    private var selectedSegmentIndex: Int = 0
    
    private var classes: [Class] { DataManager.classes }
    private(set) lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl.init(frame: .zero)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    private var missingAssignments: [Assignment] {
        var missingAssignments: [Assignment] = []
        classes.forEach { `class` in
            `class`.assignments.forEach { `assignment` in
                if `assignment`.state == .missing {
                    `assignment`.`class` = `class`
                    missingAssignments.append(`assignment`)
                }
            }
        }
        return missingAssignments
    }
    
    // used just to obtain tint color
    let button = UIButton()
    var tintColor: UIColor { button.tintColor }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        updateNumMissingAssignmentsBadge()
        
        tableView.refreshControl = refreshControl
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//        tableView.delaysContentTouches = false
    }
    
    func updateNumMissingAssignmentsBadge() {
        let num = missingAssignments.count
        if num == 0 {
            missingCircle.isHidden = true
            numMissingLabel.isHidden = true
        }
        else {
            missingCircle.isHidden = false
            numMissingLabel.isHidden = false
            numMissingLabel.text = String(num)
        }
    }
    
    @objc private func pullToRefresh() {
        Classroom.singleton.getClasses { [weak self] classes in
            DataManager.classes = classes
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
                self?.updateNumMissingAssignmentsBadge()
            }
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ClassworkVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedSegmentIndex == 1 {
            return 1
        }
        else {
            return classes.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmentIndex == 1 {
            return missingAssignments.count
        }
        else {
            let `class` = classes[section]
            if `class`.noMoreResults {
                return `class`.assignments.count
            }
            else {
                return `class`.assignments.count + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DueDateCell") as! DueDateCell
            let assignment = missingAssignments[indexPath.row]
            if let className = assignment.`class`?.name {
                cell.assignmentNameLabel.text = "(\(className)) \(assignment.title)"
            }
            else {
                cell.assignmentNameLabel.text = assignment.title
            }
            cell.icon.tintColor = tintColor
            cell.assignmentNameLabel.textColor = .label
            cell.dueDateLabel.textColor = .systemRed
            cell.dueDateLabel.text = "  Missing since\n\(assignment.dueDateAndTimeFormatted)"
            return cell
        }
        else {
            if indexPath.row < classes[indexPath.section].assignments.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DueDateCell") as! DueDateCell
                let `class` = classes[indexPath.section]
                let assignment: Assignment = `class`.assignments[indexPath.row]
                cell.assignmentNameLabel.text = assignment.title
                switch assignment.state {
                case .assigned:
                    cell.icon.tintColor = tintColor
                    cell.assignmentNameLabel.textColor = .label
                    cell.dueDateLabel.textColor = .label
                    cell.dueDateLabel.text = "  Due \(assignment.dueDateAndTimeFormatted)"
                case .turnedIn:
                    cell.icon.tintColor = .secondaryLabel
                    cell.assignmentNameLabel.textColor = .secondaryLabel
                    cell.dueDateLabel.textColor = .secondaryLabel
                    cell.dueDateLabel.text = "  Turned in"
                case .missing:
                    cell.icon.tintColor = tintColor
                    cell.assignmentNameLabel.textColor = .label
                    cell.dueDateLabel.textColor = .systemRed
                    cell.dueDateLabel.text = "  Missing since\n\(assignment.dueDateAndTimeFormatted)"
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! FooterCell
                cell.tableView = tableView
                cell.class = classes[indexPath.section]
                cell.vc = self
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selectedSegmentIndex == 1 {
            return "Missing Assignments"
        }
        else {
            return classes[section].name
        }
    }
}

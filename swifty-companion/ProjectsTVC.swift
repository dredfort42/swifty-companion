//
//  ProjectsTVC.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 04.11.2022.
//

import UIKit
import SwiftyJSON

class ProjectsTVC: UITableViewController {

	var jsonData: JSON?
	var login: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return (login ?? "peer") + "'s projects"
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return jsonData!.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var status: String = ""
		let projectStatus: String =  jsonData![indexPath.row]["status"].string ?? ""
		switch projectStatus {
			case "finished":
				if let mark = jsonData![indexPath.row]["final_mark"].int {
					status = String(mark)
				}
			case "parent":
				status = "[oo]"
			case "searching_a_group":
				status = "[searching a group]"
			case "in_progress":
				status = "[in progress]"
			case "creating_group":
				status = "[creating group]"
			default:
				status = ""

		}

		let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectsTableViewCell
		cell.projectNameLabelView.text = jsonData![indexPath.row]["project"]["name"].string
		cell.statusLabelView.text = status

		return cell
	}

}

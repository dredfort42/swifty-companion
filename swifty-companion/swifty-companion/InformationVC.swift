//
//  InformationVC.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 03.11.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class InformationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var jsonData: JSON?

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var loginLabelView: UILabel!
	@IBOutlet weak var locationLabelView: UILabel!
	@IBOutlet weak var walletLabelView: UILabel!
	@IBOutlet weak var levelLabelView: UILabel!
	@IBOutlet weak var progressBarView: UIProgressView!
	@IBOutlet weak var skillTableView: UITableView!
	@IBOutlet weak var displayUserProjectsButtonView: UIButton!

	@IBAction func displayUserProjectsButtonAction(_ sender: UIButton) {
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		skillTableView.delegate = self
		skillTableView.dataSource = self

		loadImage()
		showMainInformation()
		updateView()
	}

	func loadImage() {
		imageView.image = UIImage.init(named: "Logo")
		imageView.layer.borderWidth = 0
		imageView.layer.cornerRadius = 0
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill

		if let imageURL = jsonData!["image_url"].string {
			AF.request(imageURL, method: .get).responseData {
				response in
				switch response.result {
					case .success:
						print("[v] Image received")
						self.imageView.image = UIImage(data: response.value!)
						self.imageView.layer.borderWidth = 1
						self.imageView.layer.borderColor = UIColor.black.cgColor
						self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
					case .failure:
						print("[x] Image not received")
				}
			}
		}
	}

	func showMainInformation() {
		loginLabelView.text = jsonData!["login"].string
		locationLabelView.text = jsonData!["campus"][0]["name"].string

		if let wallet = jsonData!["wallet"].int {
			walletLabelView.text = "Wallet: \(wallet) ₳"
		}

		if let level = jsonData!["cursus_users"][1]["level"].float {
			levelLabelView.text = "level \(Int(level)) - \(Int(modf(level).1 * 100))%"
			progressBarView.progress = 0
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return jsonData!["cursus_users"][1]["skills"].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillsTableViewCell
		cell.skillNameLabelView.text = jsonData!["cursus_users"][1]["skills"][indexPath.row]["name"].string
		cell.skillPercentageLabelView.text = String(jsonData!["cursus_users"][1]["skills"][indexPath.row]["level"].float ?? 0.0) + "%"
		cell.progressBarView.setProgress((jsonData!["cursus_users"][1]["skills"][indexPath.row]["level"].float ?? 0.0) / 100, animated: true)
		return cell
	}

	func updateView() {
		progressBarView.layer.cornerRadius = progressBarView.frame.height / 2
		progressBarView.clipsToBounds = true
		progressBarView.layer.sublayers![1].cornerRadius = progressBarView.layer.cornerRadius
		progressBarView.subviews[1].clipsToBounds = true
		progressBarView.layer.borderWidth = 1
		progressBarView.layer.borderColor = UIColor.black.cgColor
		progressBarView.progressTintColor = .black
		progressBarView.trackTintColor = .white
		progressBarView.setProgress(modf(jsonData!["cursus_users"][1]["level"].float ?? 0).1, animated: true)

		skillTableView.separatorStyle = .none
		skillTableView.showsVerticalScrollIndicator = false

		displayUserProjectsButtonView.layer.borderWidth = 1
		displayUserProjectsButtonView.layer.borderColor = UIColor.black.cgColor
		displayUserProjectsButtonView.layer.cornerRadius = 6
		displayUserProjectsButtonView.backgroundColor = .white
		displayUserProjectsButtonView.setTitleColor(.black, for: .normal)
		displayUserProjectsButtonView.setTitleColor(.gray, for: .highlighted)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowUserProjects" {
			let newView = segue.destination as! ProjectsTVC
			newView.jsonData = jsonData!["projects_users"]
			newView.login = jsonData!["login"].string
		}
	}
}

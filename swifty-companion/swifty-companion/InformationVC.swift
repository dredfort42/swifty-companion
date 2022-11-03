//
//  InformationVC.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 03.11.2022.
//

import UIKit
import SwiftyJSON

class InformationVC: UIViewController {

	var jsonData: JSON?
	{
		didSet {
			print("--- LoginInformation ---")
			print(jsonData ?? "oh no...")
		}
	}

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var loginLabelView: UILabel!
	@IBOutlet weak var locationLabelView: UILabel!
	@IBOutlet weak var walletLabelView: UILabel!
	@IBOutlet weak var levelLabelView: UILabel!
	@IBOutlet weak var progressBarView: UIProgressView!


	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.

		loginLabelView.text = jsonData!["login"].string
		locationLabelView.text = jsonData!["campus"][0]["name"].string

		if let wallet = jsonData!["wallet"].int {
			walletLabelView.text = "Wallet: \(wallet) ₳"
		}

		if let level = jsonData!["cursus_users"][1]["level"].float {
			levelLabelView.text = "level \(Int(level)) - \(Int(modf(level).1 * 100))%"
			progressBarView.progress = modf(level).1
		}

		loadImage()
		updateView()
	}

	func loadImage() {
		imageView.image = UIImage.init(named: "Logo")
		imageView.layer.borderWidth = 0
		imageView.layer.cornerRadius = 0
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill

		if jsonData!["image_url"].string != nil {
			let imageURL = URL(string: jsonData!["image_url"].string!)
			guard let url = imageURL else { return }
			let dataTask = URLSession.shared.dataTask(with: url) {
				(data, response, error) in
				if error == nil {
					if let data = data {
						DispatchQueue.main.async {
							self.imageView.image = UIImage(data: data)
							self.imageView.layer.borderWidth = 1
							self.imageView.layer.borderColor = UIColor.black.cgColor
							self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
						}
					}
				}
			}
			dataTask.resume()
		}
	}

	func updateView() {
		progressBarView.layer.cornerRadius = 6
		progressBarView.clipsToBounds = true
		progressBarView.layer.sublayers![1].cornerRadius = 6
		progressBarView.subviews[1].clipsToBounds = true
		progressBarView.progressTintColor = UIColor.black
		progressBarView.setProgress(progressBarView.progress, animated: true)

	}

}

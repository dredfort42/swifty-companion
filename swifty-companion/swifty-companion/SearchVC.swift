//
//  SearchVC.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 30.10.2022.
//

import UIKit
import SwiftyJSON

class SearchVC: UIViewController {

	var jsonData: JSON?;

	@IBOutlet weak var enterLoginFieldView: UITextField!
	@IBOutlet weak var searchButtonView: UIButton!
	@IBOutlet weak var errorMessageView: UILabel!

	@IBAction func searchButtonAction(_ sender: UIButton) {
		errorMessageView.isHidden = true
		if enterLoginFieldView.hasText {
			enterLoginFieldView.text!.replace(" ", with: "")
			LoginData.getLoginInformation(login: enterLoginFieldView.text!) {
				completionOfReceipt in
				if !(completionOfReceipt?.isEmpty ?? true) {
					self.jsonData = completionOfReceipt
					self.performSegue(withIdentifier: "ShowLoginInformation", sender: nil)
				} else {
					self.errorMessageView.isHidden = false
				}
			}
			enterLoginFieldView.text = ""
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		OAuth.checkToken()
		updateView()
	}

	func updateView() {
		enterLoginFieldView.layer.borderWidth = 1
		enterLoginFieldView.layer.borderColor = UIColor.black.cgColor
		enterLoginFieldView.layer.cornerRadius = 6

		searchButtonView.layer.borderWidth = 1
		searchButtonView.layer.borderColor = UIColor.black.cgColor
		searchButtonView.layer.cornerRadius = 6
		searchButtonView.backgroundColor = .white
		searchButtonView.setTitleColor(.black, for: .normal)
		searchButtonView.setTitleColor(.gray, for: .highlighted)

		errorMessageView.isHidden = true
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowLoginInformation" {
			let newView = segue.destination as! InformationVC
			newView.jsonData = jsonData
		}
	}
}


//
//  SkillsTableViewCell.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 04.11.2022.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

	@IBOutlet weak var skillNameLabelView: UILabel!
	@IBOutlet weak var skillPercentageLabelView: UILabel!
	@IBOutlet weak var progressBarView: UIProgressView!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		progressBarView.layer.borderWidth = 1
		progressBarView.layer.borderColor = UIColor.black.cgColor
		progressBarView.progressTintColor = .black
		progressBarView.trackTintColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

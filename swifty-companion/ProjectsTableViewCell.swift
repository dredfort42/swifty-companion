//
//  ProjectsTableViewCell.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 04.11.2022.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

	@IBOutlet weak var projectNameLabelView: UILabel!
	@IBOutlet weak var statusLabelView: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

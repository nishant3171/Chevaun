//
//  ExperienceCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ExperienceCell: UITableViewCell {
    
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(experience: ExperienceModel) {
        experienceLabel.text = experience.experience
        dateLabel.text = experience.timeStamp
    }
}

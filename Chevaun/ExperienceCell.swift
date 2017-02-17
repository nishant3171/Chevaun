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
    @IBOutlet weak var experienceImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        experienceImage.clipsToBounds = true
    }

    func configureCell(experience: ExperienceModel) {
        
        if experience.imageURL == nil && experience.experience != nil {
            experienceLabel.isHidden = false
            experienceLabel.text = experience.experience
            dateLabel.text = experience.timeStamp
            experienceImage.image = nil
        } else {
            experienceLabel.text = nil
            experienceLabel.isHidden = true
            let imageView: UIImageView = experienceImage
            if let imageURL = experience.imageURL {
                let imageUrl = URL(string: imageURL)
                imageView.sd_setImage(with: imageUrl)
            }
        }
    }
}

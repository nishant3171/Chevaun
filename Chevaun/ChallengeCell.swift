//
//  ChallengeCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 26/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ChallengeCell: UITableViewCell {
    
    @IBOutlet weak var mainFocusImage: UIImageView!
    @IBOutlet weak var funTaskImage: UIImageView!
    @IBOutlet weak var mainFocusName: UILabel!
    @IBOutlet weak var funTaskName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        mainFocusImage.clipsToBounds = true
        funTaskImage.clipsToBounds = true
    }

    func configureCell(growthActivity: ActivityModel, funActivity: ActivityModel) {
        
        mainFocusName.text = growthActivity.name
        funTaskName.text = funActivity.name
        
        if growthActivity.image != nil, funActivity.image != nil {
            self.mainFocusImage.image = growthActivity.image
            self.funTaskImage.image = funActivity.image
        } else {
            let imageView: UIImageView = self.mainFocusImage
            let imageURL = URL(string: growthActivity.imageURL)
            imageView.sd_setImage(with: imageURL)
            
            let funImageView: UIImageView = self.funTaskImage
            let funImageURL = URL(string: funActivity.imageURL)
            funImageView.sd_setImage(with: funImageURL)
        }
    }
}

//
//  ActivityCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 24/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var activityDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        activityImage.clipsToBounds = true
    }

    func configureCell(activity: ActivityModel) {
        
        self.activityDescription.text = activity.description
        self.activityName.text = activity.name
        
        if activity.image != nil {
            self.activityImage.image = activity.image
        } else {
            
            let imageView: UIImageView = self.activityImage
            let imageURL = URL(string: activity.imageURL)
            imageView.sd_setImage(with: imageURL)
            
        }
        
    }
    
}

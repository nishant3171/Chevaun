//
//  ActivityCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 24/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import Firebase

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
            if let imageURL = activity.imageURL {
                let ref = FIRStorage.storage().reference(forURL: imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("Unable to download image from Firebase Storage.")
                    } else {
                        print("Image downloaded from Firebase Storage.")
                        if let imageData = data {
                            if let image = UIImage(data: imageData) {
                                self.activityImage.image = image
                                ActivityViewController.imageCache.setObject(image, forKey: activity.imageURL as NSString)
                            }
                        }
                    }
                })
            }
        }
    }
    
}

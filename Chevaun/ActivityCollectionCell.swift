//
//  ActivityCollectionCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 31/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ActivityCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var finalReview: UILabel!
    @IBOutlet weak var labelView: UIView!
    override func draw(_ rect: CGRect) {
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = labelView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        labelView.insertSubview(blurEffectView, at: 0)
        
        activityImage.clipsToBounds = true
        activityImage.layer.cornerRadius = 2.0
        activityImage.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(activity: ActivityModel) {
        
        self.activityName.text = activity.name
        self.finalReview.text = activity.review
        
        if activity.image != nil {
            self.activityImage.image = activity.image
            
        } else {
            let imageView: UIImageView = self.activityImage
            let imageURL = URL(string: activity.imageURL)
            imageView.sd_setImage(with: imageURL)
            
        }
        
    }
}

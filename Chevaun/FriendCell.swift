//
//  FriendCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendDescription: UILabel!
    @IBOutlet weak var finalReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        
        friendImage.layer.cornerRadius = friendImage.frame.size.width / 2
        friendImage.clipsToBounds = true
    }
    
    func configureCell(friend: FriendModel) {
        
        self.friendDescription.text = friend.description
        self.friendName.text = friend.name
        self.finalReview.text = friend.review
        
        if friend.image != nil {
            self.friendImage.image = friend.image
        } else {
            
            let imageView: UIImageView = self.friendImage
            let imageURL = URL(string: friend.imageURL)
            imageView.sd_setImage(with: imageURL)
            
        }
        
        print(friend.review)
        print(friend.funPercentage)
        print(friend.intellectualPercentage)
        print(friend.emotionalPercentage)
        
    }


}

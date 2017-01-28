//
//  ChallengeFriendsCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 27/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ChallengeFriendsCell: UITableViewCell {
    
    @IBOutlet weak var intellectProfileImage: UIImageView!
    @IBOutlet weak var intellectFriendName: UILabel!
    @IBOutlet weak var funProfileImage: UIImageView!
    @IBOutlet weak var funFriendName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        intellectProfileImage.clipsToBounds = true
        intellectProfileImage.layer.cornerRadius = intellectProfileImage.bounds.size.width / 2
        
        funProfileImage.clipsToBounds = true
        funProfileImage.layer.cornerRadius = funProfileImage.bounds.size.width / 2
    }
    
    func configureCell(intellectFriend: FriendModel, funFriend: FriendModel) {
        intellectFriendName.text = intellectFriend.name
        funFriendName.text = funFriend.name
        
        if intellectFriend.image != nil {
            intellectProfileImage.image = intellectFriend.image
        } else {
            let imageView: UIImageView = intellectProfileImage
            let imageURL = URL(string: intellectFriend.imageURL)
            imageView.sd_setImage(with: imageURL)
        }
        
        if funFriend.image != nil {
            funProfileImage.image = funFriend.image
        } else {
            let imageView: UIImageView = funProfileImage
            let imageURL = URL(string: funFriend.imageURL)
            imageView.sd_setImage(with: imageURL)
        }
    }

}

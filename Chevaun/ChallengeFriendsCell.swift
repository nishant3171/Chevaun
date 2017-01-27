//
//  ChallengeFriendsCell.swift
//  Chevaun
//
//  Created by Nishant Punia on 27/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ChallengeFriendsCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var friendName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
    }
    
    func configureCell(friend: FriendModel) {
        friendName.text = friend.name
        
        if friend.image != nil {
            profileImageView.image = friend.image
        } else {
            let imageView: UIImageView = profileImageView
            let imageURL = URL(string: friend.imageURL)
            imageView.sd_setImage(with: imageURL)
        }
    }

}

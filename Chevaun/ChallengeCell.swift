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

}

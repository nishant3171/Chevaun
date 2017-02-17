//
//  ExperienceModel.swift
//  Chevaun
//
//  Created by Nishant Punia on 21/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ExperienceModel {
    var experience: String?
    var image: UIImage?
    var imageURL: String?
    var imageHeight: CGFloat?
    var imageWidth: CGFloat?
    var timeStamp: String?
    
    init(postData: Dictionary<String,AnyObject>) {
        
        if let experience = postData["experience"] {
            self.experience = experience as? String
        }
        
        if let timeStamp = postData["timeStamp"] {
            self.timeStamp = timeStamp as? String
        }
        
        if let imageURL = postData["imageURL"] {
            self.imageURL = imageURL as? String
        }
        
        if let imageHeight = postData["imageHeight"] {
            self.imageHeight = imageHeight as? CGFloat
        }
        
        if let imageWidth = postData["imageWidth"] {
            self.imageWidth = imageWidth as? CGFloat
        }
    }
}

//
//  ExperienceModel.swift
//  Chevaun
//
//  Created by Nishant Punia on 21/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import Foundation

class ExperienceModel {
    var experience: String?
    var timeStamp: String?
    
    init(postData: Dictionary<String,AnyObject>) {
        
        if let experience = postData["experience"] {
            self.experience = experience as? String
        }
        
        if let timeStamp = postData["timeStamp"] {
            self.timeStamp = timeStamp as? String
        }
    }
}

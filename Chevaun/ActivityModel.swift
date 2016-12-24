//
//  ActivityModel.swift
//  Chevaun
//
//  Created by Nishant Punia on 24/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import Foundation
import UIKit

class ActivityModel {
    
    var name: String
    var description: String?
    var image: UIImage?
    var review: String
    
    init(name: String,description: String?, image: UIImage?, review: String) {
        self.name = name
        self.description = description
        self.image = image
        self.review = review
    }
    
}

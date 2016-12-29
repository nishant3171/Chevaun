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
    
    var name: String!
    var description: String?
    var image: UIImage?
    var imageURL: String!
//    var review: String!
    var date: String!
    var postKey: String!
    
    init(name: String,description: String?, image: UIImage? ,date: String) {
        self.name = name
        self.description = description
        self.image = image
//        self.review = review
        self.date = date
    }
    
    init(postKey: String,postData: Dictionary<String,String>) {
        self.postKey = postKey
        
        if let name = postData["nameofActivity"] {
            self.name = name
        }
        
        if let description = postData["description"] {
            self.description = description
        }
        
        if let imageURL = postData["imageURL"] {
            self.imageURL = imageURL
            if let image = ActivityViewController.imageCache.object(forKey: imageURL as NSString) {
                self.image = image
            } else {
                self.image = nil
            }
        }
        
        if let date = postData["date"] {
            self.date = date
        }
    }
    
    
    
}

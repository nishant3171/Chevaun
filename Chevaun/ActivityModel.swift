//
//  ActivityModel.swift
//  Chevaun
//
//  Created by Nishant Punia on 24/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ActivityModel {
    
    var name: String!
    var description: String?
    var image: UIImage?
    var imageURL: String!
    var review: String!
    var funPercentage: Int!
    var growthPercentage: Int!
    var satisfactionPercentage: Int!
    var date: String!
    var postKey: String!
    
    init(name: String,description: String?, image: UIImage? ,date: String) {
        self.name = name
        self.description = description
        self.image = image
        self.date = date
    }
    
    init(postKey: String,postData: Dictionary<String,AnyObject>) {
        self.postKey = postKey
        
        if let name = postData["nameofActivity"] {
            self.name = name as! String
        }
        
        if let description = postData["description"] {
            self.description = description as? String
        }
        
        if let imageURL = postData["imageURL"] {
            self.imageURL = imageURL as! String
//            if let image = ActivityViewController.imageCache.object(forKey: imageURL as! NSString) {
//                self.image = image
//            } else {
//                self.image = nil
//            }
        }
        
        if let date = postData["date"] {
            self.date = date as! String
        }
        
        if let review = postData["reviewString"] {
            self.review = review as! String
        }
        
        if let growthPercentage = postData["growthPercentage"] {
            self.growthPercentage = growthPercentage as! Int
        }
        
        if let funPercentage = postData["funPercentage"] {
            self.funPercentage = funPercentage as! Int
        }
        
        if let satisfactionPercentage = postData["satisfactionPercentage"] {
            self.satisfactionPercentage = satisfactionPercentage as! Int
        }
        
    }
    
    
}



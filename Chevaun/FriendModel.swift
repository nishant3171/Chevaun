//
//  FriendModel.swift
//  Chevaun
//
//  Created by Nishant Punia on 19/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FriendModel {

var name: String!
var description: String?
var image: UIImage?
var imageURL: String!
var review: String!
var funPercentage: Int!
var emotionalPercentage: Int!
var intellectualPercentage: Int!
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
        if let image = ActivityViewController.imageCache.object(forKey: imageURL as! NSString) {
            self.image = image
        } else {
            self.image = nil
        }
    }
    
    if let date = postData["date"] {
        self.date = date as! String
    }
    
    if let review = postData["reviewString"] {
        self.review = review as! String
    }
    
    if let emotionalPercentage = postData["emotionalPercentage"] {
        self.emotionalPercentage = emotionalPercentage as! Int
    }
    
    if let funPercentage = postData["funPercentage"] {
        self.funPercentage = funPercentage as! Int
    }
    
    if let intellectualPercentage = postData["intellectualPercentage"] {
        self.intellectualPercentage = intellectualPercentage as! Int
    }
    
}

}

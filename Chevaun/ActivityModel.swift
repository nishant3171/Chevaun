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
    
//    fileprivate var dataTask: URLSessionDownloadTask? = nil
    
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
    
//    func downloadingImage(completionClosure closure: @escaping (_ image: UIImage) -> Void) {
//        
//        let ref = FIRStorage.storage().reference(forURL: imageURL)
//        
////        let download = DispatchQueue(label: "dowloadImage")
//        
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
//            ref.data(withMaxSize: 2 * 1024 * 1024) { (data, error) in
//                if error != nil {
//                    print("Unable to download from Firebase.")
//                } else {
//                    print("Image downloaded from Firebase.")
//                    if let imageData = data {
//                        let image = UIImage(data: imageData)!
//                        ActivityViewController.imageCache.setObject(image, forKey: self.imageURL as NSString)
//                        DispatchQueue.main.async {
//                            closure(image)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    if activity.image != nil {
//    self.activityImage.image = activity.image
//    } else {
//    if let imageURL = activity.imageURL {
//    let ref = FIRStorage.storage().reference(forURL: imageURL)
//    ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
//    if error != nil {
//    print("Unable to download image from Firebase Storage.")
//    } else {
//    print("Image downloaded from Firebase Storage.")
//    if let imageData = data {
//    if let image = UIImage(data: imageData) {
//    self.activityImage.image = image
//    ActivityViewController.imageCache.setObject(image, forKey: activity.imageURL as NSString)
//    }
//    }
//    }
//    })
//    }
//    }
    
//    static func sorting(lhs: ActivityModel,rhs: ActivityModel) -> Bool {
//        return lhs.date.localizedStandardCompare(rhs.date) == .orderedDescending
//    }
    
    
}



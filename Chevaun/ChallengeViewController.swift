//
//  ChallengeViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 06/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class ChallengeViewController: UIViewController {
    
//    @IBOutlet weak var mainFocusImage: UIImageView!
//    @IBOutlet weak var funTaskImage: UIImageView!
//    @IBOutlet weak var mainFocusName: UILabel!
//    @IBOutlet weak var funTaskName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var newActivities = [ActivityModel]()
    var arrayForMainFocus = [ActivityModel]()
    var arrayForFunTask = [ActivityModel]()
    
    var friends = [FriendModel]()
    
    struct tableViewCellIdentifiers {
        static let challengeFriendsCell = "ChallengeFriends"
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mainFocusImage.clipsToBounds = true
//        funTaskImage.clipsToBounds = true
        automaticallyAdjustsScrollViewInsets = false
        
        let cellNib = UINib(nibName: tableViewCellIdentifiers.challengeFriendsCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: tableViewCellIdentifiers.challengeFriendsCell)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 360
        
        downloadingActivitiesFromFirebase()
        downloadingFriendsFromFirebase()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadingActivitiesFromFirebase() {
        
        if let newString = UserDefaults.standard.string(forKey: "UID") {
            DataService.instance.REF_ACTIVITIES.child(newString).observe(.value, with: { (snapshot) in
                let download = DispatchQueue(label: "download", attributes: [])
                print(DataService.instance.REF_USERS.child(newString))
                download.async {
                    var activity = [ActivityModel]()
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshot {
                            if let postDict = snap.value as? Dictionary<String,AnyObject> {
                                let key = snap.key
                                let post = ActivityModel(postKey: key, postData: postDict)
                                activity.append(post)
                            }
                        }
                    }
                
                activity.sort{($0.date > $1.date)}
                
                self.newActivities = activity
                print(self.newActivities)
                self.preparingDailyChallenges(activities: self.newActivities)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                
                }
            })
                
        }
        
    }
    
    func downloadingFriendsFromFirebase() {
        
        let download = DispatchQueue(label: "download", attributes: [])
        download.async {
            
            if let newString = UserDefaults.standard.string(forKey: "UID") {
                DataService.instance.REF_FRIENDS.child(newString).observe(.value, with: { (snapshot) in
                    print(DataService.instance.REF_USERS.child(newString))
                    var friend = [FriendModel]()
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshot {
                            print(snap)
                            if let postDict = snap.value as? Dictionary<String,AnyObject> {
                                let key = snap.key
                                let post = FriendModel(postKey: key, postData: postDict)
                                friend.append(post)
                            }
                        }
                    }
                    friend.sort{($0.date > $1.date)}
                    self.friends = friend
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                })
            }
        }
        
    }
    
    
    func preparingDailyChallenges(activities: [ActivityModel]) {
        
        var maxGrowthArray = [Int]()
        var maxFunArray = [Int]()
        
        
        for activity in activities {
            
            if let maxGrowth = activity.growthPercentage {
                maxGrowthArray.append(maxGrowth)
            }
            
            if let maxFun = activity.funPercentage {
                maxFunArray.append(maxFun)
            }
            
        }
        
        for growthActivity in activities {
        
            if let maxGrowthValue = maxGrowthArray.max() {
                if growthActivity.growthPercentage == maxGrowthValue {
                    print(maxGrowthValue)
                    arrayForMainFocus.append(growthActivity)
                }
            }
            
        }
        
        for funActivity in activities {
            
            if let maxFunValue = maxFunArray.max() {
                if funActivity.funPercentage == maxFunValue {
                    print(maxFunValue)
                    arrayForFunTask.append(funActivity)
                }
            }
            
        }
        
        print(arrayForMainFocus.count)
        
//        if (arrayForMainFocus[0].image != nil),arrayForFunTask[0].image != nil {
//            self.mainFocusImage.image = arrayForMainFocus[0].image
//        } else {
//            
//            let imageView: UIImageView = self.mainFocusImage
//            let imageURL = URL(string: arrayForMainFocus[0].imageURL)
//            imageView.sd_setImage(with: imageURL)
//            
//            let funImageView: UIImageView = self.funTaskImage
//            let funImageURL = URL(string: arrayForFunTask[0].imageURL)
//            funImageView.sd_setImage(with: funImageURL)
//        }
//        
//        if let activityName = arrayForMainFocus[0].name, let funName = arrayForFunTask[0].name {
//            mainFocusName.text = activityName
//            funTaskName.text = funName
//        }
        
        
    }

}

//MARK: TableViewDataSource

extension ChallengeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayForMainFocus.count == 0 && arrayForFunTask.count == 0 {
            return 0
        } else if friends.count < 2 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainChallengeCell", for: indexPath) as! ChallengeCell
        cell.configureCell(growthActivity: arrayForMainFocus[indexPath.row], funActivity: arrayForFunTask[indexPath.row])
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifiers.challengeFriendsCell, for: indexPath) as! ChallengeFriendsCell
            if indexPath.row - 1 >= 0 {
            cell.configureCell(intellectFriend: friends[indexPath.row], funFriend: friends[indexPath.row - 1] )
            return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    
}

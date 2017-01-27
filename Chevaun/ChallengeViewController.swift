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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mainFocusImage.clipsToBounds = true
//        funTaskImage.clipsToBounds = true
        automaticallyAdjustsScrollViewInsets = false
        downloadingActivitiesFromFirebase()
        
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
        if arrayForMainFocus.count == 0 {
            return arrayForMainFocus.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainChallengeCell", for: indexPath) as! ChallengeCell
        cell.configureCell(growthActivity: arrayForMainFocus[indexPath.row], funActivity: arrayForFunTask[indexPath.row])
        return cell
    }
    
    
}

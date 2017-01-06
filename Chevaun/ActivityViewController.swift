//
//  ViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 21/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import Firebase

var activities = [ActivityModel]()
class ActivityViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
//    var activities: [ActivityModel] {
//        return (UIApplication.shared.delegate as! AppDelegate).activities
//    }
    
    
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        if let newString = UserDefaults.standard.string(forKey: "UID") {
            DataService.instance.REF_ACTIVITIES.child(newString).observe(.value, with: { (snapshot) in
                print(DataService.instance.REF_USERS.child(newString))
                var activity = [ActivityModel]()
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshot {
                        print(snap)
                        if let postDict = snap.value as? Dictionary<String,AnyObject> {
                            let key = snap.key
                            let post = ActivityModel(postKey: key, postData: postDict)
                            activity.append(post)
                        }
                    }
                }
                activity.sort{($0.date > $1.date)}
                activities = activity
//                self.activities.sort{($0.date > $1.date)}
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        tableView.reloadData()
    }
    
}

//MARK: TableViewDataSource
extension ActivityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(activities.count)
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
//        activities.sort{($0.date > $1.date)}
        let activity = activities[indexPath.row]
        print(activity)
        print(activities[indexPath.row])
        
        if let activityImage = activities[indexPath.row].image {
            print(activityImage)
        }
        
        cell.configureCell(activity: activities[indexPath.row])

        return cell
    
    }
    
}

extension ActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddNewActivity") as! AddNewActivityViewController
        destination.newActivity = activities[indexPath.row]
        print(destination.newActivity!)
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
}


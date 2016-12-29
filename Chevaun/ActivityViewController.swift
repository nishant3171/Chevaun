//
//  ViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 21/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import Firebase


class ActivityViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var activities: [ActivityModel] {
        return (UIApplication.shared.delegate as! AppDelegate).activities
    }
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        if let newString = UserDefaults.standard.string(forKey: "UID") {
            DataService.instance.REF_ACTIVITIES.child(newString).observe(.value, with: { (snapshot) in
                print(DataService.instance.REF_USERS.child(newString))
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshot {
                        print(snap)
                        if let postDict = snap.value as? Dictionary<String,String> {
                            let key = snap.key
                            let post = ActivityModel(postKey: key, postData: postDict)
                            let object = UIApplication.shared.delegate
                            let appDelegate = object as! AppDelegate
                            appDelegate.activities.append(post)
                        }
                    }
                }
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
        let activity = activities[indexPath.row]
        print(activity)
        print(activities[indexPath.row])
        
        if let activityImage = activities[indexPath.row].image {
            print(activityImage)
        }
        
        cell.configureCell(activity: activities[indexPath.row])
        
        
        
        
//        if let description = activity.description, let image = activity.image {
//            cell.configureCell(name: activity.name, description: description, image: image)
//        }
        return cell
        
//        return UITableViewCell()
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


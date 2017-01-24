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
    
    @IBOutlet weak var tableView: UITableView!
    
    var activities = [ActivityModel]()
    var percentageComplete = 0.0
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        detectingNetworkConnections()
        detectingFirebaseConnections()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        downloadingActivitiesFromFirebase()
        print(percentageComplete)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadingActivitiesFromFirebase() {
        
        if let newString = UserDefaults.standard.string(forKey: "UID") {
            DataService.instance.REF_ACTIVITIES.child(newString).observe(.value, with: { (snapshot) in
                let download = DispatchQueue(label: "download", attributes: [])
                
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
                    self.activities = activity
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
                
            })
        }
        
    }
    
    func detectingFirebaseConnections() {
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool {
                if connected {
                    print("Connected")
                }
            } else {
                print("Not connected")
                self.alertController(title: "Not Connected To Internet", subtitle: "Please check your internet connection.")
            }
        })
    }
    
    func detectingNetworkConnections() {
        if Reachability.isInternetAvailable() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            self.alertController(title: "Not Connected To Our Servers", subtitle: "Please check your internet connection.")
        }
    }
    
    
    func alertController(title: String ,subtitle: String) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        alert.addAction(cancelAction)
        alert.addAction(tryAgainAction)
        
        self.present(alert, animated: true, completion: nil)
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
//        let activity = activities[indexPath.row]
//        print(activity)
//        print(activities[indexPath.row])
        
        cell.configureCell(activity: activities[indexPath.row])

        return cell
    
    }
    
}

extension ActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddNewActivity") as! AddNewActivityViewController
        destination.newActivity = activities[indexPath.row]
//        print(destination.newActivity!)
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    
}


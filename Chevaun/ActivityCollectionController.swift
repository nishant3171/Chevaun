//
//  ActivityCollectionController.swift
//  Chevaun
//
//  Created by Nishant Punia on 31/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class ActivityCollectionController: UICollectionViewController {
    
    var activities = [ActivityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (collectionView!.frame.width)
        let height = width / 2
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        
//        detectingNetworkConnections()
//        detectingFirebaseConnections()
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        downloadingActivitiesFromFirebase()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("I am loadin,,,")
        checkingUser()
        detectingNetworkConnections()
        detectingFirebaseConnections()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        downloadingActivitiesFromFirebase()
        print("I am done.")
        collectionView?.reloadData()
        collectionView?.setNeedsDisplay()
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func checkingUser() {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print(user.uid)
            } else {
                print("User signed out.")
                self.activities = []
            }
        })
    }
    
    
    func downloadingActivitiesFromFirebase() {
        
        if UserDefaults.standard.string(forKey: "UID") == nil {
            print("Reloading Collection View.")
        }
        
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
                        self.collectionView!.reloadData()
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
        alert.addAction(tryAgainAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
}

extension ActivityCollectionController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollection", for: indexPath) as! ActivityCollectionCell
        cell.configureCell(activity: activities[indexPath.row])
        return cell
    }
}

extension ActivityCollectionController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddNewActivity") as! AddNewActivityViewController
        destination.newActivity = activities[indexPath.row]
        //        print(destination.newActivity!)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
}

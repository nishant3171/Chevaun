//
//  FriendViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class FriendViewController: UIViewController {

    @IBOutlet var friendTableView: UITableView!
    
    var friends = [FriendModel]()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        detectingNetworkConnections()
        detectingFirebaseConnections()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        downloadingFriendsFromFirebase()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
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
                        self.friendTableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                })
            }
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

//MARK: TableViewDataSource
extension FriendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(friends.count)
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friend = friends[indexPath.row]
        print(friend)
        print(friends[indexPath.row])
        
        if let friendImage = friends[indexPath.row].image {
            print(friendImage)
        }
        
        if let experience = friends[indexPath.row].experiences {
            print(experience)
        }
        
        cell.configureCell(friend: friends[indexPath.row])
        
        return cell
        
    }
    
}

extension FriendViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "FriendMessages") as! FriendExperienceViewController
        destination.newFriend = friends[indexPath.row]
        print(destination.newFriend!)
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
}


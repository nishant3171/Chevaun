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
                self.friendTableView.reloadData()
                
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.configureCell(friend: friends[indexPath.row])
        
        return cell
        
    }
    
}

//extension FriendViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddNewActivity") as! AddingNewFriendViewController
//        destination.newFriend = friends[indexPath.row]
//        print(destination.newFriend!)
//        self.navigationController?.pushViewController(destination, animated: true)
//        
//    }
//    
//}


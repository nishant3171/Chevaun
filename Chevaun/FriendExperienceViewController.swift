//
//  FriendExperienceViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class FriendExperienceViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var reviewButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var newFriend: FriendModel? {
        didSet {
            navigationItem.title = newFriend?.name
        }
    }
    var review: [Int] = [0,0,0]
    var reviewString = String()
    var experiences = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if newFriend != nil {
            settingUpActivityFromTableView()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.reloadData()
        
        navigationController?.tabBarController?.tabBar.isHidden = true
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func reivewButtonTapped(_ sender: UIButton) {
//        
//        let destination = self.storyboard?.instantiateViewController(withIdentifier: "MeetingReviewController") as! ReviewMeetingViewController
//        destination.newFriend = newFriend
//        destination.reviewDelegate = self
//        self.present(destination, animated: true, completion: nil)
//    }
    
    @IBAction func addExperienceButtonTapped(sender: UIButton) {
        
        if let experience = experienceTextField.text {
            experiences.append(experience)
        }
        sendingExperiencesToFirebase()
    }
    
    func settingUpActivityFromTableView() {
        
//        experienceTextField.text = newFriend.description
        review[0] = (newFriend?.funPercentage)!
        review[1] = (newFriend?.intellectualPercentage)!
        review[2] = (newFriend?.emotionalPercentage)!
        reviewString = (newFriend?.review)!
        
    }
    
    func sendingExperiencesToFirebase() {
        
        if let experience = experienceTextField.text,let userId = USER_ID, let postKey = newFriend?.postKey {
            let post: Dictionary<String,AnyObject> = [
                "experience": experience as AnyObject
            ]
            let firebasePost = DataService.instance.REF_EXPERIENCES.child(userId).child(postKey).childByAutoId()
            firebasePost.setValue(post)
        }
    }
    
//    func uploadingActivitiesToFirebase(imageURL: String) {
//        if let name = activityNameTextField.text, let description = descriptionTextView.text, let newString = defaults.string(forKey: "UID") {
//            //Check Dictionary is <String, String>
//            let post: Dictionary<String, AnyObject> = [
//                "nameofActivity": name as AnyObject,
//                "description": description as AnyObject,
//                "imageURL": imageURL as AnyObject,
//                "date": timeStamp as AnyObject,
//                "funPercentage": review[0] as AnyObject,
//                "growthPercentage": review[1] as AnyObject,
//                "satisfactionPercentage": review[2] as AnyObject,
//                "reviewString": reviewString as AnyObject
//            ]
//            let firebasePost = DataService.instance.REF_ACTIVITIES.child(newString).childByAutoId()
//            firebasePost.setValue(post)
//        }
//    }
    

}

//MARK: TableViewDataSource

extension FriendExperienceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as! ExperienceCell
        
        if let friend = newFriend {
            cell.configureCell(friend: friend)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}

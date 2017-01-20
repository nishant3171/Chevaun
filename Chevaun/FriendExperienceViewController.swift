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
    var newFriend: FriendModel!
    var review: [Int] = [0,0,0]
    var reviewString = String()

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
    
    func settingUpActivityFromTableView() {
        
//        experienceTextField.text = newFriend.description
        review[0] = (newFriend.funPercentage)!
        review[1] = (newFriend.intellectualPercentage)!
        review[2] = (newFriend.emotionalPercentage)!
        reviewString = (newFriend.review)!
        
    }
    

}

//MARK: TableViewDataSource

extension FriendExperienceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as! ExperienceCell
        
        cell.configureCell(friend: newFriend)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}

//
//  FriendExperienceViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase


class FriendExperienceViewController: UIViewController, UITextFieldDelegate, ReviewMeetingViewControllerDelegate {
    
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
    var experiences = [ExperienceModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if newFriend != nil {
            settingUpActivityFromTableView()
        }
        
        experienceTextField.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        downloadingExperiencesFromFirebase()
        
        navigationController?.tabBarController?.tabBar.isHidden = true
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadingExperiencesFromFirebase() {
        
        let download = DispatchQueue(label: "download", attributes: [])
        
        download.async {
            if let userId = USER_ID, let postKey = self.newFriend?.postKey {
                DataService.instance.REF_EXPERIENCES.child(userId).child(postKey).observe(.value, with: { (snapshot) in
                    print(DataService.instance.REF_EXPERIENCES.child(userId).child(postKey))
                    var experience = [ExperienceModel]()
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshot {
                            print(snap)
                            if let postDict = snap.value as? Dictionary<String,AnyObject> {
                                let post = ExperienceModel(postData: postDict)
                                experience.append(post)
                            }
                        }
                    }
                    self.experiences = experience
                    print(self.experiences[0].experience!)
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.rowHeight = UITableViewAutomaticDimension
                        self.tableView.estimatedRowHeight = 80
                        self.tableView.reloadData()
                    }
                    
                    
                    
                    
                })
            }
        }
        
    }
    
    @IBAction func reivewButtonTapped(_ sender: UIButton) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "MeetingReviewController") as! ReviewMeetingViewController
        destination.newFriend = newFriend
        destination.reviewDelegate = self
        self.present(destination, animated: true, completion: nil)
    }
    
    func sendValue(fun: Float, intellectual: Float, emotional: Float, finalReview: String) {
        review[0] = Int(fun)
        review[1] = Int(intellectual)
        review[2] = Int(emotional)
        reviewString = finalReview
    }
    
    @IBAction func addExperienceButtonTapped(sender: UIButton) {
        
        sendingExperiencesToFirebase()
        experienceTextField.text = ""
        experienceTextField.resignFirstResponder()
        
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
    
    func sendingFirstExperienceToFirebase() {
        if let experience = newFriend?.description,let userId = USER_ID, let postKey = newFriend?.postKey {
            let post: Dictionary<String,AnyObject> = [
                "experience": experience as AnyObject
            ]
            let firebasePost = DataService.instance.REF_EXPERIENCES.child(userId).child(postKey).childByAutoId()
            firebasePost.setValue(post)
        }
    }
    
    
    
    func observeExperiences() {
        if let userId = USER_ID, let postKey = newFriend?.postKey {
            DataService.instance.REF_EXPERIENCES.child(userId).child(postKey).observe(.value, with: { (snapshot) in
                var experience = [ExperienceModel]()
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let post = ExperienceModel(postData: dictionary)
                    experience.append(post)
                }
                self.experiences = experience
//                self.experiences.insert(experience1, at: 0)
                print(self.experiences[0].experience!)
                
                
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 80
                self.tableView.reloadData()
                
                
                
            }, withCancel: nil)
        }
    }
    
    
    //Notifications
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    func keyboardWillShow(_ notification: Notification) {
        
        let keyboardSize = getKeyboardHeight(notification)
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize
            
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

//MARK: TableViewDataSource

extension FriendExperienceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(experiences.count)
        return experiences.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as! ExperienceCell
        
        let experience = experiences[indexPath.row]
        cell.configureCell(experience: experience)
        return cell
        
    }
    
    
    
}

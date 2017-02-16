//
//  FriendExperienceViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 20/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase



class FriendExperienceViewController: UIViewController, UITextFieldDelegate, ReviewMeetingViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
//    let imageView = UIImageView()
    
    //MARK: Variables
    var newFriend: FriendModel?
//    var newFriend: FriendModel? {
//        didSet {
//            navigationItem.title = newFriend?.name
//            settingUpUserProfile()
//        }
//    }
    var review: [Int] = [0,0,0]
    var reviewString = String()
    var experiences = [ExperienceModel]()
    var timeStamp: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if newFriend != nil {
            settingUpActivityFromTableView()
        }
        
//        settingUpUserProfile()
        experienceTextField.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        timeStamp = convertingDateToString()
        print(timeStamp!)
        downloadingExperiencesFromFirebase()
        
        let rightBarButton = UIBarButtonItem(title: "Review", style: .plain, target: self, action: #selector(reivewButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        
 
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        settingUpUserProfile()
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
    
    func settingUpUserProfile() {
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = .red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        containerView.addSubview(profileImageView)
        
        if let imageUrl = newFriend?.imageURL {
            
            let url = URL(string: imageUrl)
            profileImageView.sd_setImage(with: url)
            
        }
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        containerView.addSubview(nameLabel)
        
        nameLabel.text = newFriend?.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
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
                        self.settingUpUserProfile()
                        self.tableView.rowHeight = UITableViewAutomaticDimension
                        self.tableView.estimatedRowHeight = 80
                        self.tableView.reloadData()
                        self.tableViewScrollToBottom(animated: true)
                    }
                    
                    
                    
                    
                })
            }
        }
        
    }
    
    func reivewButtonTapped() {
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
    
    @IBAction func galleryImageTapped(sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let galleryImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print(galleryImage)
            selectedImage = galleryImage
        }
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage
        }
        
        if let pickedImage = selectedImage {
            print(pickedImage)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
                "experience": experience as AnyObject,
                "timeStamp": timeStamp as AnyObject
            ]
            let firebasePost = DataService.instance.REF_EXPERIENCES.child(userId).child(postKey).childByAutoId()
            firebasePost.setValue(post)
        }
    }
    
    func convertingDateToString() -> String {
        
        let dateOfActivity = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let timeStamp = formatter.string(from: dateOfActivity)
        print(timeStamp)
        return timeStamp
        
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

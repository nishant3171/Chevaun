//
//  AddingNewFriendViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 19/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class AddingNewFriendViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate,ReviewMeetingViewControllerDelegate {

    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var friendNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    //MARK: Constants
    let defaults = UserDefaults.standard
    
    //MARK: Variables
    var imagePicker: UIImagePickerController!
    var newFriend: FriendModel?
    var timeStamp = String()
    var review: [Int] = [0,0,0]
    var reviewString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        friendNameTextField.delegate = self
        descriptionTextView.delegate = self
        
        if newFriend != nil {
            settingUpActivityFromTableView()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        friendProfileImage.clipsToBounds = true
        friendProfileImage.layer.cornerRadius = 60
        subscribeToNotifications()
        
        print(review[0])
        print(review[1])
        print(review[2])
        print(reviewString)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotification()
    }
    
    @IBAction func reivewButtonTapped(_ sender: UIButton) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "MeetingReviewController") as! ReviewMeetingViewController
        destination.newFriend = newFriend
        destination.reviewDelegate = self
        self.present(destination, animated: true, completion: nil)
    }
    
    @IBAction func pickingGalleryImage(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let galleryImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print(galleryImage)
            self.friendProfileImage.image = galleryImage
        }
        
        self.dismiss(animated: true, completion: nil)
        
        self.galleryButton.isHidden = true
        self.cameraButton.isHidden = true
    }
    
    @IBAction func takingImageFromCamera(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savingActivity(_ sender: UIButton) {
        
        convertingDateToString()
        
        if newFriend == nil, let mainImage = friendProfileImage.image {
            
            if let imageData = UIImageJPEGRepresentation(mainImage, 0.2),let newString = defaults.string(forKey: "UID")  {
                
                let imageUID = NSUUID().uuidString
                let metadata = FIRStorageMetadata()
                metadata.contentType = "jpeg"
                
                DataService.instance.REF_FRIENDIMAGES.child(newString).child(imageUID).put(imageData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("Unable to upload images.")
                    } else {
                        print("Successfully uploaded image to Firebase.")
                        if let downloadURL = metadata?.downloadURL()?.absoluteString {
                            self.uploadingActivitiesToFirebase(imageURL: downloadURL)
                        }
                    }
                }
            }
        } else {
            newFriend?.image = friendProfileImage.image
            newFriend?.description = descriptionTextView.text
            newFriend?.name = friendNameTextField.text!
            newFriend?.date = timeStamp
            newFriend?.funPercentage = review[0]
            newFriend?.intellectualPercentage = review[1]
            newFriend?.emotionalPercentage = review[2]
            newFriend?.review = reviewString
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendValue(fun: Float, intellectual: Float, emotional: Float, finalReview: String) {
        review[0] = Int(fun)
        review[1] = Int(intellectual)
        review[2] = Int(emotional)
        reviewString = finalReview
    }
    
    func uploadingActivitiesToFirebase(imageURL: String) {
        if let name = friendNameTextField.text, let description = descriptionTextView.text, let newString = defaults.string(forKey: "UID") {
            //Check Dictionary is <String, String>
            let post: Dictionary<String, AnyObject> = [
                "nameofFriend": name as AnyObject,
                "description": description as AnyObject,
                "imageURL": imageURL as AnyObject,
                "date": timeStamp as AnyObject,
                "funPercentage": review[0] as AnyObject,
                "intellectualPercentage": review[1] as AnyObject,
                "emotionalPercentage": review[2] as AnyObject,
                "reviewString": reviewString as AnyObject,
                "experiences": description as AnyObject
            ]
            let firebasePost = DataService.instance.REF_FRIENDS.child(newString).childByAutoId()
            firebasePost.setValue(post)
            
            
            if let experience = descriptionTextView.text,let userId = USER_ID {
                let post: Dictionary<String,AnyObject> = [
                    "experience": experience as AnyObject
                ]
                let firebasePost = DataService.instance.REF_EXPERIENCES.child(userId).child(firebasePost.key).childByAutoId()
                firebasePost.setValue(post)
            }
            
        }
        
        
    }
    
    
    func settingUpActivityFromTableView() {
        
        descriptionTextView.text = newFriend?.description
        friendNameTextField.text = newFriend?.name
        review[0] = (newFriend?.funPercentage)!
        review[1] = (newFriend?.intellectualPercentage)!
        review[2] = (newFriend?.emotionalPercentage)!
        reviewString = (newFriend?.review)!
        
        if newFriend?.image != nil {
            self.friendProfileImage.image = newFriend?.image
        } else {
            
            
            if let imageURL = newFriend?.imageURL {
                let url = URL(string: imageURL)
                let imageView: UIImageView = self.friendProfileImage
                imageView.sd_setImage(with: url)
            }
        }
        
        galleryButton.isHidden = true
        cameraButton.isHidden = true
        
        //        let button1 = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(getter: UIDynamicBehavior.action))
        //        self.navigationItem.setRightBarButton(button1, animated: true)
        
    }
    
    func convertingDateToString() {
        
        let dateOfActivity = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        
        
        
        timeStamp = formatter.string(from: dateOfActivity)
        print(timeStamp)
        
    }
    
    //MARK: Keyboard Notifications
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    func keyboardWillShow(_ notification: Notification) {
        //        if writingTextView.editable == true {
        ////            view.frame.origin.y -= getKeyboardHeight(notification)
        //            writingTextView.contentInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: getKeyboardHeight(notification), right: 8.0)
        //        }
        
        let keyboardSize = getKeyboardHeight(notification)
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize
            //            toolbar.isHidden = true
            let range = NSMakeRange(descriptionTextView.text.characters.count - 1, 0)
            descriptionTextView.scrollRangeToVisible(range)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
        //        toolbar.isHidden = false
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
    
    //MARK: Text View Configuration
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            
            return false
        } else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionTextView.text = ""
    }
    

}

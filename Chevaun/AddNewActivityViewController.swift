//
//  DetailWorkViewController.swift
//  Chattels
//
//  Created by Nishant Punia on 29/07/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import Firebase
//import SDWebImage

class AddNewActivityViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,ActivityReviewViewControllerDelegate {
    
    //MARK: IBOutlets
    

    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var activityNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var mainActivityImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!

    
    //MARK: Constants
    let defaults = UserDefaults.standard
    
    //MARK: Variables
    var imagePicker: UIImagePickerController!
    var newActivity: ActivityModel?
    var timeStamp = String()
    var review: [Int] = [0,0,0]
    var reviewString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        activityNameTextField.delegate = self
        descriptionTextView.delegate = self
        
        if newActivity != nil {
            settingUpActivityFromTableView()
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        mainActivityImage.clipsToBounds = true
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
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ActivityReviewViewController
        destination.newActivity = newActivity
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
            self.mainActivityImage.image = galleryImage
        }
        
        self.dismiss(animated: true, completion: nil)
        
        self.galleryButton.isHidden = true
        self.cameraButton.isHidden = true
    }
    
    @IBAction func takingImageFromCamera(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func savingActivity(_ sender: UIButton) {
        
        convertingDateToString()
        
        
        
        if newActivity == nil, let changeImage = mainActivityImage.image {
            
            let mainImage = resizeImage(image: changeImage, newWidth: 800)
            print(mainImage?.size.width as Any)
            print(mainImage?.size.height as Any)
            
            //Change ! in line below for image
            if let imageData = UIImageJPEGRepresentation(mainImage!, 0.3),let newString = defaults.string(forKey: "UID")  {
                
                let imageUID = NSUUID().uuidString
                let metadata = FIRStorageMetadata()
                metadata.contentType = "jpeg"
                
//                let uploadTask = DataService.instance.REF_ACTIVITYIMAGES.child(newString).child(imageUID).put(imageData, metadata: metadata)
//                var percentageComplete = 0.0
                
                DataService.instance.REF_ACTIVITYIMAGES.child(newString).child(imageUID).put(imageData, metadata: metadata) { (metadata, error) in
                    
                    
                    
//                    uploadTask.observe(.progress) { snapshot in
//                        // Upload reported progress
//                        percentageComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                            / Double(snapshot.progress!.totalUnitCount)
//                        
//                    }
                    if error != nil {
                        print("Unable to upload images.")
                    } else {
                        print("Successfully uploaded image to Firebase.")
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        self.uploadingActivitiesToFirebase(imageURL: downloadURL)
//                        print(percentageComplete)
//                        self.presetingActivityViewController(percentage: percentageComplete)
                    }
                    }
                }
            }
            
        } else {
            newActivity?.image = mainActivityImage.image
            newActivity?.description = descriptionTextView.text
            newActivity?.name = activityNameTextField.text!
            newActivity?.date = timeStamp
            newActivity?.funPercentage = review[0]
            newActivity?.growthPercentage = review[1]
            newActivity?.satisfactionPercentage = review[2]
            newActivity?.review = reviewString
        }

        self.dismiss(animated: true, completion: nil)
    }
    
//    func presetingActivityViewController(percentage: Double) {
//        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
//        
//        controller.percentageComplete = percentage
//        
//        self.present(controller, animated: true, completion: nil)
//        
//        
//    }
    
    func sendValue(fun: Float, growth: Float, satisfaction: Float, finalReview: String) {
        review[0] = Int(fun)
        review[1] = Int(growth)
        review[2] = Int(satisfaction)
        reviewString = finalReview
    }
    
    func uploadingActivitiesToFirebase(imageURL: String) {
        if let name = activityNameTextField.text, let description = descriptionTextView.text, let newString = defaults.string(forKey: "UID") {
            //Check Dictionary is <String, String>
        let post: Dictionary<String, AnyObject> = [
            "nameofActivity": name as AnyObject,
            "description": description as AnyObject,
            "imageURL": imageURL as AnyObject,
            "date": timeStamp as AnyObject,
            "funPercentage": review[0] as AnyObject,
            "growthPercentage": review[1] as AnyObject,
            "satisfactionPercentage": review[2] as AnyObject,
            "reviewString": reviewString as AnyObject
        ]
        let firebasePost = DataService.instance.REF_ACTIVITIES.child(newString).childByAutoId()
            firebasePost.setValue(post)
        }
    }
    

    func settingUpActivityFromTableView() {
        
        descriptionTextView.text = newActivity?.description
        activityNameTextField.text = newActivity?.name
        review[0] = (newActivity?.funPercentage)!
        review[1] = (newActivity?.growthPercentage)!
        review[2] = (newActivity?.satisfactionPercentage)!
        reviewString = (newActivity?.review)!
        
        if newActivity?.image != nil {
            self.mainActivityImage.image = newActivity?.image
        } else {

            
            if let imageURL = newActivity?.imageURL {
                let url = URL(string: imageURL)
                let imageView: UIImageView = self.mainActivityImage
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


//
//  DetailWorkViewController.swift
//  Chattels
//
//  Created by Nishant Punia on 29/07/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit

class AddNewActivityViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    //MARK: IBOutlets
    

    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var activityNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var mainActivityImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!

    
    //MARK: Variables
    var imagePicker: UIImagePickerController!
    var newActivity: ActivityModel?
    
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
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotification()
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
    
    @IBAction func savingActivity(_ sender: UIButton) {
        
        if newActivity == nil {
        if let mainImage = mainActivityImage.image, let name = activityNameTextField.text, let description = descriptionTextView.text {
            print(mainImage)
            let activity = ActivityModel(name: name, description: description, image: mainImage, review: "Fun Activity")
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.activities.append(activity)
        }
        } else {
            newActivity?.image = mainActivityImage.image
            newActivity?.description = descriptionTextView.text
            newActivity?.name = activityNameTextField.text!
        }

        self.dismiss(animated: true, completion: nil)
    }
    

    func settingUpActivityFromTableView() {
        
        mainActivityImage.image = newActivity?.image
        descriptionTextView.text = newActivity?.description
        activityNameTextField.text = newActivity?.name
        
        galleryButton.isHidden = true
        cameraButton.isHidden = true
        
//        let button1 = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(getter: UIDynamicBehavior.action))
//        self.navigationItem.setRightBarButton(button1, animated: true)
    
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
    
}


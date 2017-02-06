//
//  ProfileViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 21/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.layer.cornerRadius = 3.0
        loginView.layer.cornerRadius = 3.0

        roundedView(views: logoView)
        roundedView(views: facebookView)
        roundedView(views: googleView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func roundedView(views: UIView) {
        views.layer.cornerRadius =  views.frame.width / 2
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginEmailTapped(sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginViewController") as! EmailLoginViewController
        self.present(destination, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Service not yet available.")
            return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                if let newUser = user {
                    let userData = ["provider": "Email"]
                    DataService.instance.saveUser(uid: newUser.uid, userData: userData)
                    print(newUser.uid)
                }
                
            }
        })
        
        
        
    }
    
    @IBAction func facebookLogin(sender: UITapGestureRecognizer) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook.")
            } else if result?.isCancelled == true {
                print("You are not giving the permissions.")
            } else {
                print("Successfully authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthentication(credential)
            }
        }
    }

    func firebaseAuthentication(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase.\(error)")
            } else if user?.uid != nil {
                
                if let newUser = user {
                let userData = ["provider": credential.provider]
                DataService.instance.saveUser(uid: newUser.uid, userData: userData)
                    print(newUser.uid)
                    
                UserDefaults.standard.set(newUser.uid, forKey: "UID")
                    //Save UID in constants file. See the example from Udacity.
                print("Authenticated with Firebase.")
                    
                }
            }
            else {
                print("Couldn't get the user id.")
            }
        })
    }
}

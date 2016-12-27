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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if FIRAuth.auth()?.currentUser != nil {
            infoLabel.text = "Already logged in."
        } else {
            infoLabel.text = "Please sign up."
        }
        
//        infoLabel.text = "Already logged in."
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        
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
                print("Authenticated with Firebase.")
                self.infoLabel.text = "Thanks for signing in."
                }
            }
            else {
                print("Couldn't get the user id.")
            }
        })
    }
}

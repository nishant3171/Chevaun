//
//  EmailLoginViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 03/02/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class EmailLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        logoView.layer.cornerRadius = logoView.frame.width / 2
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Not Valid Entries")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Logged in with user.")
                
                let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController") as! UITabBarController
                destination.selectedIndex = 2
                self.present(destination, animated: true, completion: nil)
                
            }
        })
    }
}

//
//  ProfileViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 02/02/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    struct tableViewCellIdentifiers {
        static let settingsCell = "SettingsCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: tableViewCellIdentifiers.settingsCell, bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: tableViewCellIdentifiers.settingsCell)

        automaticallyAdjustsScrollViewInsets = false
        self.tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 100.0
        tableview.reloadData()
    }
    
    @IBAction func addAccountButtonTapped(sender: UIButton) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(destination, animated: true, completion: nil)
    }
    
    func loggingOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            print("Signed Out.")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func printing() {
        print("Test")
    }

}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddingAccount", for: indexPath) as UITableViewCell
            return cell
        } else {
            let cell = tableview.dequeueReusableCell(withIdentifier: tableViewCellIdentifiers.settingsCell, for: indexPath)
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            printing()
            loggingOut()
        }
    }
}

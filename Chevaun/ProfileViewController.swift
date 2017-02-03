//
//  ProfileViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 02/02/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        tableview.reloadData()
    }
    
    @IBAction func addAccountButtonTapped(sender: UIButton) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(destination, animated: true, completion: nil)
    }

}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddingAccount", for: indexPath) as UITableViewCell
        return cell
    }
}

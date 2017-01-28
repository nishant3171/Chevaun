//
//  HappeningsViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 06/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class HappeningsViewController: UIViewController {

    @IBOutlet weak var newActivityButton: UIButton!
    @IBOutlet weak var newFriend: UIButton!
    @IBOutlet weak var shadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        newActivityButton.layer.cornerRadius = 3.0
        newFriend.layer.cornerRadius = 3.0
        
//        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
//        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        shadowView.layer.shadowOpacity = 0.4
//        shadowView.layer.shadowRadius = 0.0
//        shadowView.layer.masksToBounds = false
        
        
    }
    
    
    @IBAction func addingNewActivity(sender: UIButton) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddNewActivity") as! AddNewActivityViewController
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    @IBAction func addingNewFriend(sender: UIButton) {
        
        let destination1 = self.storyboard?.instantiateViewController(withIdentifier: "AddNewFriend") as! AddingNewFriendViewController
        self.navigationController?.pushViewController(destination1, animated: true)
        
    }

}

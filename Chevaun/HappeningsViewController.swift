//
//  HappeningsViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 06/01/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

class HappeningsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

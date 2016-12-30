//
//  ActivityReviewViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 30/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit

class ActivityReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

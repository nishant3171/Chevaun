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
    @IBOutlet weak var activityShadowView: UIView!
    
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
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView.layer.shadowRadius = 10
        
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        
        shadowView.layer.shouldRasterize = true
        
        activityShadowView.layer.shadowColor = UIColor.black.cgColor
        activityShadowView.layer.shadowOpacity = 0.3
        activityShadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        activityShadowView.layer.shadowRadius = 10
        
        activityShadowView.layer.shadowPath = UIBezierPath(rect: activityShadowView.bounds).cgPath
        
        activityShadowView.layer.shouldRasterize = true
        
        
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

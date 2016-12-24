//
//  ViewController.swift
//  Chevaun
//
//  Created by Nishant Punia on 21/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    var activities = [ActivityModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: TableViewDataSource
extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
//        cell.configureCell(activity: activities[indexPath.row])
//        return cell
        
        return UITableViewCell()
    }
    
}


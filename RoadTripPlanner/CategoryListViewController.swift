//
//  CategoryListViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/11/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Parse

class CategoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
    }
   
    /*@IBAction*/ func onLogout(_ sender: Any) {
        let manager = FBSDKLoginManager()
        manager.logOut()
                
    }
}

extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripListCell", for: indexPath) as! BusinessCell
        tripCell.selectionStyle = .none
        
        return tripCell
        
            
    }
    
}


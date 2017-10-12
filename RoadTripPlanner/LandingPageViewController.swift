//
//  LandingPageViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/10/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var createTripButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTripButton.layer.cornerRadius = createTripButton.frame.height / 2
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LandingPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2  {
            return 30.0
        }
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            case 0, 2 : let headerCell = tableView.dequeueReusableCell(withIdentifier: "TripHeaderCell", for: indexPath) as! UITableViewCell
                    return headerCell

            case 1, 3 :  let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
                    tripCell.selectionStyle = .none

                    return tripCell
            default:  return UITableViewCell()

            
        }

    }
    
    
}

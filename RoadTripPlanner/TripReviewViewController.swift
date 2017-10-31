//
//  TripReviewViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/30/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class TripReviewViewController: UIViewController {

    static func storyboardInstance() -> TripReviewViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? TripReviewViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

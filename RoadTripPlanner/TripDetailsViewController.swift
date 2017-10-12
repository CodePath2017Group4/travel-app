//
//  TripsDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/12/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
    @IBOutlet weak var emailGroupImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let emailGroupImageTap = UITapGestureRecognizer(target: self, action: #selector(emailGroupImageTapped))
        emailGroupImageTap.numberOfTapsRequired = 1
        emailGroupImageView.isUserInteractionEnabled = true
        emailGroupImageView.addGestureRecognizer(emailGroupImageTap)
    }
    
    func emailGroupImageTapped(_ sender: AnyObject) {
        
        
    }
}

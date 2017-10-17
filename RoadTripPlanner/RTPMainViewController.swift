//
//  RTPMainViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/16/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class RTPMainViewController: UIViewController {

    @IBOutlet weak var profilePictureButton: ProfilePictureButton!
    
    static func storyboardInstance() -> RTPMainViewController? {
        
        let storyboard = UIStoryboard(name: "RTPMainViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? RTPMainViewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profilePictureButtonPressed(_ sender: ProfilePictureButton) {
        // Return to the login view controller
        returnToLoginViewController()
    }
    
    fileprivate func returnToLoginViewController() {
        self.dismiss(animated: true, completion: nil)
    }

}

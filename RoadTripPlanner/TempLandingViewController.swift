//
//  TempLandingViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

enum PlaceCategory {
    case None
    case GasStation
    case Hotel
    case Food
}

class TempLandingViewController: UIViewController {

    var selectedCategory = PlaceCategory.None
    
    @IBOutlet weak var startTripButton: UIButton!
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "TempLandingViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTripButton.layer.cornerRadius = 5
        
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startTripButtonPressed(_ sender: Any) {
        // Push the TempLandingViewController onto the navigation stack
        guard let createTripVC = TempCreateTripViewController.storyboardInstance() else {
            return
        }
        createTripVC.selectedCategory = self.selectedCategory
        navigationController?.pushViewController(createTripVC, animated: true)
    }
    
    @IBAction func hotelsPressed(_ sender: Any) {
        selectedCategory = PlaceCategory.Hotel
    }
    
    
    @IBAction func gasStationsPressed(_ sender: Any) {
        selectedCategory = PlaceCategory.GasStation
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

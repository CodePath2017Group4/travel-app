//
//  TabBarViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/17/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Create view controllers from storyboard.
        let tripsNavigtaionController = storyboard.instantiateViewController(withIdentifier: "LandingPage") as! UINavigationController
        tripsNavigtaionController.tabBarItem = UITabBarItem(title: "Trips", image: #imageLiteral(resourceName: "trip-tab"), tag: 0)
        
        // Add the log out button to the view controller navigation item.
        addLogoutButton(to: tripsNavigtaionController)
        
        let albumsNavigtaionViewController = storyboard.instantiateViewController(withIdentifier: "PhotoGallery") as! UINavigationController
        albumsNavigtaionViewController.tabBarItem = UITabBarItem(title: "Albums", image: #imageLiteral(resourceName: "album-tab"), tag: 1)
        
        addLogoutButton(to: albumsNavigtaionViewController)
        
        let profileNavigtaionController = storyboard.instantiateViewController(withIdentifier: "Profile") as! UINavigationController
        profileNavigtaionController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profile-tab"), tag: 2)
        
        addLogoutButton(to: profileNavigtaionController)
        
        let viewControllerList = [tripsNavigtaionController, albumsNavigtaionViewController, profileNavigtaionController]
        
        // Set the viewControllers property of our UITabBarController
        viewControllers = viewControllerList
    }
    
    fileprivate func addLogoutButton(to navigationController: UINavigationController) {
        let topViewController = navigationController.topViewController
        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutButtonPressed))
    }
    
    func logoutButtonPressed() {
        log.info("Log out pressed")
        PFUser.logOut()
        
        // Return to login screen.
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

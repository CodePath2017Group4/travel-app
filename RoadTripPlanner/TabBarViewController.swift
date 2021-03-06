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
        let tripsNavigtaionController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.TripsNavigationController) as! UINavigationController
//        let tripsNavigtaionController = TempLandingViewController.storyboardInstance()!
        tripsNavigtaionController.tabBarItem = UITabBarItem(title: "Trips", image: #imageLiteral(resourceName: "trip-tab"), tag: 0)
        // Add the log out button to the view controller navigation item.
        addLogoutButton(to: tripsNavigtaionController)
        
        let albumsNavigtaionViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.AlbumsNavigationController) as! UINavigationController
        albumsNavigtaionViewController.tabBarItem = UITabBarItem(title: "Albums", image: #imageLiteral(resourceName: "album-tab"), tag: 1)
        
        addLogoutButton(to: albumsNavigtaionViewController)
        
        let notificationsNavigationController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.NotificationNavigationController) as! UINavigationController
        notificationsNavigationController.tabBarItem = UITabBarItem(title: "Notifications", image: #imageLiteral(resourceName: "notification-tab"), tag: 2)
        
        let profileNavigationController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ProfileNavigationController) as! UINavigationController
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profile-tab"), tag: 3)
        
        addLogoutButton(to: profileNavigationController)
        
        // Set the appearance of the tab bar
        UITabBar.appearance().tintColor = Constants.Colors.ColorPalette3495Color2
        
        let viewControllerList = [tripsNavigtaionController, albumsNavigtaionViewController, notificationsNavigationController, profileNavigationController]
        
        // Set the viewControllers property of our UITabBarController
        viewControllers = viewControllerList
    }
    
    fileprivate func addLogoutButton(to navigationController: UINavigationController) {
        let topViewController = navigationController.topViewController
//        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutButtonPressed))
        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "md_logout"), style: .plain, target: self, action: #selector(logoutButtonPressed))
    }
    
    func logoutButtonPressed() {
        
        PFUser.logOut()

        // Return to login screen.
        dismiss(animated: true, completion: nil)
        
        // Post a notification
        NotificationCenter.default.post(name: Constants.NotificationNames.LogoutPressedNotification, object: nil, userInfo: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

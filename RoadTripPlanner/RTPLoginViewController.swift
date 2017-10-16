//
//  RTPLoginViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/16/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit


class RTPLoginViewController: UIViewController {
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    static func storyboardInstance() -> RTPLoginViewController? {
        let storyboard = UIStoryboard(name: "RTPLoginViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? RTPLoginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if we already have a user logged in.
        if FBSDKAccessToken.current() != nil {
            
            // User is logged in, so go to the next view controller.
//            showTabController()
            log.verbose("A user is already logged in.")
        }
        
        // Set the read permissions.
        fbLoginButton.readPermissions = ["email","public_profile","user_friends"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func showTabController() {
        let navPage = (self.storyboard?.instantiateViewController(withIdentifier: "TabController"))!
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = navPage
    }

}

extension RTPLoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        log.verbose("Logout button pressed")
        
        // On logOut, the user is logged out of the app. it will not logout from user fb account. Only workaround is it to go into safari, get to Facebook.com and logout from user account.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!,
                     didCompleteWith result: FBSDKLoginManagerLoginResult!,
                     error: Error!) {
        if error != nil {
            log.error(error)
        } else {
            log.info("logged in with result: \(result)")
        }
    }
    
}

//
//  LoginViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/11/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }


    
    @IBAction func onFbLogin(_ sender: Any) {
        if FBSDKAccessToken.current() != nil {

            User.fetchProfile()
            
        } else {

            let loginManager = FBSDKLoginManager()

            loginManager.logIn(withReadPermissions: ["email","public_profile","user_friends"], from: self, handler: { (loginResults: FBSDKLoginManagerLoginResult?, error: Error?) -> Void in
                
                if !(loginResults?.isCancelled)! {
                    User.fetchProfile()
                    
                } else {    // Sign in request cancelled
                    // handle error object
                    print("Error \(error?.localizedDescription)")

                }
            })
        }
                
        
    }
}

extension LoginViewController:  FBSDKLoginButtonDelegate {
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        // On logOut, the user is logged out of the app. it will not logout from user fb account. Only workaround is it to go into safari, get to Facebook.com and logout from user account.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else {
            User.fetchProfile()
            
        }
    }
    
}

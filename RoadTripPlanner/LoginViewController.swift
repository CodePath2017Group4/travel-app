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
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    static func storyboardInstance() -> LoginViewController? {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? LoginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.ViewBackgroundColor
        loginButton.backgroundColor = Constants.Colors.ButtonBackgroundColor
        
        // Round the corners of the loginButton
        loginButton.layer.cornerRadius = 5
        
    }

    // MARK: IBAction
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    
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
                    print("Error \(String(describing: error?.localizedDescription))")

                }
            })
        }
                
        
    }
    
    // MARK:
    
    fileprivate func loginUser() {
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                log.error("Error: \(error)")
                self.showErrorAlert(title: "Login Failed", message: error.localizedDescription)
            } else {
                log.info("User logged in successfully")
                // manually segue to logged in view
                self.presentLoggedInScreen()
            }
        }
    }
    
    fileprivate func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // dismiss the view
        }
        
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true) {
            
        }
    }
    
    fileprivate func presentLoggedInScreen() {
        let tabBarViewController = TabBarViewController()
        self.present(tabBarViewController, animated: true, completion: nil)
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

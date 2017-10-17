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
import ParseFacebookUtils

class RTPLoginViewController: UIViewController {
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var continueButton: UIButton!
    
    fileprivate var viewIsVisible: Bool = false
    fileprivate var viewDidAppear: Bool = false
    
    static func storyboardInstance() -> RTPLoginViewController? {
        let storyboard = UIStoryboard(name: "RTPLoginViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? RTPLoginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fbLoginButton.delegate = self
        
        registerObservers()
        
        // Set the read permissions.
        fbLoginButton.readPermissions = ["email","public_profile","user_friends"]
        
//        PFFacebookUtils.logIn(withPermissions: ["email","public_profile","user_friends"], block: { (user: PFUser?, error: Error?) in
//            if user == nil {
//                if error != nil {
//                    log.error("Error logging in with Parse: \(String(describing: error))")
//                }
//            } else {
//                if let user = user {
//                    if user.isNew {
//                        log.info("Hi there new user!")
//                    } else {
//                        log.info("Got a user")
//                    }
//                }
//                
//            }
//        })
        
        
        // Check if we already have a user logged in.
        if FBSDKAccessToken.current() != nil {
            
            log.verbose("A user is already logged in.")
            
            checkProfile()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Once the view has appeared we can present the main view controller (if a user is logged in).
        
        if viewDidAppear {
            viewIsVisible = true
        } else {
            
            if FBSDKAccessToken.current() != nil {
                gotoMainViewController()
            } else {
                viewIsVisible = true
            }
            
            viewDidAppear = true
        }
    }
    
    deinit {
        // unregister observers
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewIsVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func registerObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeProfileChange(_:)),
                                               name: NSNotification.Name.FBSDKProfileDidChange,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeTokenChange(_:)),
                                               name: NSNotification.Name.FBSDKAccessTokenDidChange,
                                               object: nil)
    }
    
    fileprivate func showTabController() {
        let navPage = (self.storyboard?.instantiateViewController(withIdentifier: "TabController"))!
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = navPage
    }
    
    fileprivate func gotoMainViewController() {
        let mainViewController = RTPMainViewController.storyboardInstance()

        present(mainViewController!, animated: true, completion: nil)
    }

    // MARK: - Observers
    func observeProfileChange(_ notifiation: Notification) {
        checkProfile()
    }
    
    func observeTokenChange(_ notification: Notification) {
        if FBSDKAccessToken.current() == nil {
            let title = "continue as a guest"
            continueButton.setTitle(title, for: .normal)
        } else {
            checkProfile()
        }
    }
    
    // MARK: - Actions
    @IBAction func continueButtonPressed(_ sender: Any) {
        gotoMainViewController()
    }
        
    
    fileprivate func checkProfile() {
        
        FBSDKProfile.loadCurrentProfile { (profile: FBSDKProfile?, error: Error?) in
            if error != nil {
                log.error(error!)
            }
        }
        
        if FBSDKProfile.current() != nil {
            let name = FBSDKProfile.current().name!
            let title = "continue as \(name)"
            continueButton.setTitle(title, for: .normal)
            log.verbose(title)
            
            loginToParse()
            
        } else {
            log.verbose("profile was nil")
        }
    }
    
    fileprivate func loginToParse() {
        let accessToken = FBSDKAccessToken.current()!
        let currentProfile = FBSDKProfile.current()
        let userId = (currentProfile?.userID)!
        

        PFFacebookUtils.logIn(withFacebookId: userId, accessToken: accessToken.appID, expirationDate: accessToken.expirationDate) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("User logged in through Facebook!")
            } else if error != nil {
                log.error(error!)
            }
        }
    }
    
    fileprivate func showErrorAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true) {
        
        }
    }
    
}

extension RTPLoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        log.verbose("Facebook button will login..")
        
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
            log.error("Unexpected login error: \(error)")
            
            // Display an alert message
            let alertMessage = "There was a problem logging in. Please try again later."
            showErrorAlert(title: "Oops", message: alertMessage)
            
        } else {
            log.info("logged in with result: \(result)")
            if viewIsVisible {
                gotoMainViewController()
            }            
        }
    }
    
}

//
//  HomeViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/18/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "HomeViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.ViewBackgroundColor

        // Round the corners of buttons
        signUpButton.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
        
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        addNotificationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // If we have a logged in user, skip the home screen and go directly to the TabBarViewController        
        if PFUser.current() != nil {
            let tabBarViewController = TabBarViewController()
            self.present(tabBarViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomeViewController.logoutButtonPressed),
                                               name: Constants.NotificationNames.LogoutPressedNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        // Push CreateUserViewController onto navigation stack
        guard let createUserViewController = CreateUserViewController.storyboardInstance() else {
            log.info("createUserViewController is nil")
            return
        }
        
        navigationController?.pushViewController(createUserViewController, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // Push LoginViewController onto navigation stack
        guard let loginViewController = LoginViewController.storyboardInstance() else {
            log.info("loginViewController is nil")
            return
        }
        navigationController?.pushViewController(loginViewController, animated: true)
    }

    func logoutButtonPressed() {
        // Pop to the root view controller
        navigationController?.popToRootViewController(animated: false)
    }
}

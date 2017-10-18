//
//  HomeViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/18/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "HomeViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Round the corners of buttons
        signUpButton.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
        
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}

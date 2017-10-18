//
//  CreateUserViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/12/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse

class CreateUserViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    static func storyboardInstance() -> CreateUserViewController? {
        let storyboard = UIStoryboard(name: "CreateUserViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? CreateUserViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.layer.cornerRadius = 5
        
        navigationItem.title = "Sign Up"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        registerUser()
    }
    
    fileprivate func registerUser() {
        
        let newUser = PFUser()
        
        newUser.username = usernameTextField.text ?? ""
        newUser.email = emailTextField.text ?? ""
        newUser.password = passwordTextField.text ?? ""
        
        log.info("\(newUser)")
        
        newUser.signUpInBackground {(success: Bool, error: Error?) in
            if let error = error {
                log.error("Error: \(error)")
                self.showErrorAlert(title: "Sign Up Error", message: error.localizedDescription)
            } else {
                log.info("User Registered successfully")
                // manually segue to logged in view
                self.gotoLoggedInScreen()
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

    fileprivate func gotoLoggedInScreen() {
        let tabBarViewController = TabBarViewController()
        self.present(tabBarViewController, animated: true, completion: nil)
    }

}

//
//  User.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/12/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse

class User: NSObject{
    static var _currentUser: User?
    static let currentUserKey = "CurrentUserKey"
    
    var userid: String?
    var userName: String?
    var userEmail: String?
    
    var dictionary: Dictionary<String, AnyObject>?
    
    init(dictionary: Dictionary<String, AnyObject>) {
        userid = dictionary["id"] as? String
        userName = dictionary["name"] as? String
        userEmail = dictionary["email"] as? String
        
        self.dictionary = dictionary
    }
    
    init(userid: String, userName: String, userEmail: String) {
        self.userid = userid
        self.userName = userName
        self.userEmail = userEmail
    }

    class func fetchProfile() {
        
        let parameters = ["fields": "email,picture.type(large),name,gender,age_range,cover,timezone,verified,updated_time,education,religion,friends"]

        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{ (connection, result, error)-> Void in
            

            if error != nil {   // Error occured while logging in
                // handle error
                
                print("error \(error?.localizedDescription)")
                return
            }
            
            let userDictionary = result as! [String: AnyObject]
            
            let user = User(dictionary: userDictionary)
            
            User.currentUser = user

            let signedInUser: PFUser? = PFUser()
            
            signedInUser?.setObject(User.currentUser!.userName!, forKey: "username")
            signedInUser?.setObject(User.currentUser!.userEmail!, forKey: "email")
            
            // Get Facebook Profile Picture
            let userProfile = "https://graph.facebook.com/" + (User.currentUser?.userid)! + "/picture?type=large"

            let usernameLink = "https://graph.facebook.com/" + (User.currentUser?.userid)!

            let username = usernameLink.replacingOccurrences(of: "https://graph.facebook.com/", with: "")

            let profilePictureUrl = NSURL(string: userProfile)

            if profilePictureUrl != nil {
                let profilePictureData = NSData(contentsOf: profilePictureUrl as! URL)
            
                if profilePictureData != nil {
                
                    let profilePictureObject = PFFile(data: profilePictureData! as Data)
                    signedInUser?.setObject(profilePictureObject!, forKey: "profile_picture")
                
                }
            }
            
            signedInUser?.signUpInBackground {(success: Bool, error: Error?) in
                print("saveInBackground ==> \(success)")

                if(success)
                {
                    print("User details are now updated")
                }
                else {
                    print("User details not updated")
                    
                }
            }
        }
    }
    
    class var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            if _currentUser == nil {
                if let data = defaults.object(forKey: currentUserKey) as? Data {
                    
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
                        _currentUser = User(dictionary: dictionary as! Dictionary<String, AnyObject>)
                        
                    } catch {
                        print("JSON serialization error: \(error)")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if _currentUser != nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: (user?.dictionary)! as Any, options: [])
                    defaults.set(data, forKey: currentUserKey)


                } catch {
                    print("JSON deserialization error: \(error)")
                }
            } else {
                defaults.removeObject(forKey: currentUserKey)
            }
            defaults.synchronize()
        }
    }

    
}

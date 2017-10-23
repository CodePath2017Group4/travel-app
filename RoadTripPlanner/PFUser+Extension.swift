//
//  RTPUser.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/23/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import Parse

extension PFUser {
    
    var avatarFile: PFFile? {
        get {
            return self.object(forKey: "avatar") as? PFFile
        }        
        set {            
            setObject(newValue!, forKey: "avatar")
        }
    }
    
    var friends: [PFUser]? {
        get {
            return self.object(forKey: "friends") as? [PFUser]
        }
        set {
            setObject(newValue!, forKey: "friends")
        }
    }
    
    func addFriend(user: PFUser) {
        self.friends?.append(user)
    }
}

//
//  ParseBackend.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/22/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Foundation
import Parse

class ParseBackend {
    
    static func getUsers(completionHandler: @escaping ([PFUser]?, Error?) -> Void) {

        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                let users = objects as! [PFUser]
                completionHandler(users, nil)
            } else {
                completionHandler(nil, error)                
            }
        })
    }
    
    static func getTrips(completionHandler: @escaping ([Trip]?, Error?) -> Void) {
        if let user = PFUser.current() {
            let query = PFQuery(className: Trip.parseClassName())
            query.whereKey("creator", equalTo: user)
            
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    let results = objects as! [Trip]
                    completionHandler(results, nil)
                } else {
                    completionHandler(nil, error)
                }
            })
        } else {
            completionHandler([], nil)
        }
    }
    
    static func getAlbums(completionHandler: @escaping ([Album]?, Error?) -> Void) {
        if let user = PFUser.current() {
            let query = PFQuery(className: Album.parseClassName())
            query.whereKey("owner", equalTo: user)
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    let results = objects as! [Album]
                    completionHandler(results, nil)
                } else {
                    completionHandler(nil, error)
                }
            })
        } else {           
            completionHandler([], nil)
        }
    }
    
//    static func getAlbums() -> [Album] {
//        if let user = PFUser.current() {
//            let query = PFQuery(className: Album.parseClassName())
//            query.whereKey("owner", equalTo: user)
//            let results = try? query.findObjects() as! [Album]
//            if results == nil {
//                return []
//            } else {
//                return results!
//            }
//        } else {
//            return []
//        }
//    }
}

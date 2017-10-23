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
    
//    static func getTrips() -> [Trip] {
//        if let user = PFUser.current() {
//            let query = PFQuery(className: Trip.parseClassName())
//            query.whereKey("creator", equalTo: user)
//            let results = try? query.findObjects() as! [Trip]
//            if results == nil {
//                return []
//            } else {
//                return results!
//            }
//        } else {
//            return []
//        }
//    }
    
    static func getTrips(completionHandler: @escaping ([Trip]?, Error?) -> Void) {
        if let user = PFUser.current() {
            let query = PFQuery(className: Trip.parseClassName())
            query.whereKey("creator", equalTo: user)
            let results = try? query.findObjects() as! [Trip]
            if results == nil {
                completionHandler([], nil)
            } else {
                completionHandler(results, nil)
            }
        } else {
            completionHandler([], nil)
        }
    }
    
    static func getAlbums(completionHandler: @escaping ([Album]?, Error?) -> Void) {
        if let user = PFUser.current() {
            let query = PFQuery(className: Album.parseClassName())
            query.whereKey("owner", equalTo: user)
            let results = try? query.findObjects() as! [Album]
            if results == nil {
                completionHandler([], nil)
            } else {
                completionHandler(results, nil)
            }
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

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

    static func getTripsCreatedByUser(user: PFUser, completion: @escaping ([Trip]?, Error?) -> Void ) {
        let tripQuery = PFQuery(className: Trip.parseClassName())
        tripQuery.whereKey("creator", equalTo: user)
        tripQuery.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                let trips = objects as! [Trip]
                completion(trips, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    static func getTripsForUser(user: PFUser, areUpcoming: Bool, completion: @escaping ([Trip]?, Error?) -> Void) {
        
        let today = Date()
  
        let dateQuery = PFQuery(className: "Trip")
        if areUpcoming {
            dateQuery.whereKey("date", greaterThanOrEqualTo: today)
        } else {
            dateQuery.whereKey("date", lessThan: today)
        }
                
        let query = PFQuery(className: "TripMember")
        query.whereKey("user", equalTo: user)
        query.whereKey("trip", matchesQuery: dateQuery)
        query.includeKey("trip")
        query.includeKey("trip.creator")
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                var trips: [Trip] = []
                if let objects = objects {
                    log.info(objects.count)
                    for o in objects {
                        let status = o.object(forKey: "status") as? Int
                        log.info("status: \(String(describing: status))")
                        let trip = o.object(forKey: "trip") as! Trip
                        trips.append(trip)
                    }
                    completion(trips, nil)
                }
                
            } else {
                completion(nil, error)
            }
        }
    }
    
}

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
    
    static func getTripsForUser(user: PFUser, areUpcoming: Bool, onlyConfirmed: Bool, completion: @escaping ([Trip]?, Error?) -> Void) {
        
        let today = Date()
  
        let dateQuery = PFQuery(className: Trip.parseClassName())
        if areUpcoming {
            dateQuery.whereKey("date", greaterThanOrEqualTo: today)
        } else {
            dateQuery.whereKey("date", lessThan: today)
        }
                
        let query = PFQuery(className: TripMember.parseClassName())
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
                        let status = o.object(forKey: "status") as! Int
                        let isCreator = o.object(forKey: "isCreatingUser") as! Bool
                        log.info("status: \(String(describing: status))")
                        if (!onlyConfirmed || isCreator || status == InviteStatus.Confirmed.hashValue) {
                            let trip = o.object(forKey: "trip") as! Trip
                            trips.append(trip)
                        }
                    }
                    completion(trips, nil)
                }
                
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getInvitedTrips(user: PFUser, completion: @escaping ([TripMember]?, Error?) -> Void) {
        let query = PFQuery(className: TripMember.parseClassName())
        query.whereKey("user", equalTo: user)
        query.whereKey("isCreatingUser", equalTo: false)
        query.includeKey("trip")
        query.includeKey("trip.creator")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                let tripMember: [TripMember] = objects as! [TripMember]
                completion(tripMember, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getTripMemberOnTrips(trips: [Trip], excludeCreator: Bool, completion: @escaping ([TripMember]?, Error?) -> Void) {
        var completedQueries = 0
        var tripMembers: [TripMember] = []
        for trip in trips {
            let query = PFQuery(className: TripMember.parseClassName())
            query.whereKey("trip", equalTo: trip)
            if (excludeCreator) {
                query.whereKey("isCreatingUser", equalTo: false)
            }
            query.includeKey("trip")
            query.includeKey("user")
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    let tripMember: [TripMember] = objects as! [TripMember]
                    tripMembers.append(contentsOf: tripMember)
                    completedQueries = completedQueries + 1
                    if (completedQueries == trips.count) {
                        completion(tripMembers, nil)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    static func getAlbumsOnTrips(trips: [Trip], completion: @escaping ([Album]?, Error?) -> Void) {
        var completedQueries = 0
        var albums: [Album] = []
        for trip in trips {
            let query = PFQuery(className: Album.parseClassName())
            query.whereKey("trip", equalTo: trip)
            query.includeKey("trip")
            query.includeKey("owner")
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    let album: [Album] = objects as! [Album]
                    albums.append(contentsOf: album)
                    completedQueries = completedQueries + 1
                    if (completedQueries == trips.count) {
                        completion(albums, nil)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
}

//
//  Trip.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/15/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse

class Trip: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var date: Date?
    @NSManaged var startPoint: PFGeoPoint?
    @NSManaged var destinationPoint: PFGeoPoint?
    @NSManaged var users: [PFUser]
    
    class func parseClassName() -> String {
        return "Trip"
    }

}

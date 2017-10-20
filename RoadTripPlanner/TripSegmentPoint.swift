//
//  TripSegmentStart.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/19/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Parse

class TripSegmentPoint: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var geoPoint: PFGeoPoint?    
    
    class func parseClassName() -> String {
        return "TripSegmentPoint"
    }
    
}

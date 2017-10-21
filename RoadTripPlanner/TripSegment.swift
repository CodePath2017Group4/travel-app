//
//  TripSegmentStart.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/19/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Parse

class TripSegment: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var address: String?    
    @NSManaged var geoPoint: PFGeoPoint?    
    
    init(name: String, address: String, geoPoint: PFGeoPoint) {
        super.init()
        self.name = name
        self.address = address
        self.geoPoint = geoPoint
    }
    
    class func parseClassName() -> String {
        return "TripSegmentPoint"
    }
    
}

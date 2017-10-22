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
    
    override init() {
        
        super.init()
       // self.name = ""
       // self.geoPoint = PFGeoPoint()
    }
    
    init(name: String, geoPoint: PFGeoPoint) {
        super.init()
        self.name = name
        self.geoPoint = geoPoint
    }
    
    class func parseClassName() -> String {
        return "TripSegmentPoint"
    }
    
}

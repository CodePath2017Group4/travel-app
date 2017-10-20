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
    @NSManaged var startPoint: TripSegmentPoint?
    @NSManaged var destinationPoint: TripSegmentPoint?
    @NSManaged var creator: PFUser?
    @NSManaged var tripMembers: [TripMember]
    @NSManaged var albums: [Album]?
    
    class func parseClassName() -> String {
        return "Trip"
    }

}

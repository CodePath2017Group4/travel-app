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
    @NSManaged var segmentPoints: [TripSegmentPoint]?
    @NSManaged var destinationPoint: TripSegmentPoint?
    @NSManaged var creator: PFUser?
    @NSManaged var tripMembers: [TripMember]
    @NSManaged var albums: [Album]?
    
    init(name: String, date: Date, startPoint: TripSegmentPoint, destinationPoint: TripSegmentPoint, creator: PFUser) {
        super.init()
        self.name = name
        self.date = date
        self.startPoint = startPoint
        self.destinationPoint = destinationPoint
        self.creator = creator
        
        self.segmentPoints = []
        self.tripMembers = []
        self.albums = []
    }
    
    func addSegmentPoint(segmentPoint: TripSegmentPoint) {
        self.segmentPoints?.append(segmentPoint)
    }
    
    class func parseClassName() -> String {
        return "Trip"
    }

}

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
    @NSManaged var segments: [TripSegment]?
    
    @NSManaged var albums: [Album]?
    @NSManaged var creator: PFUser
    
    override init() {
        super.init()
    }
    
    init(name: String, date: Date, creator: PFUser) {
        super.init()
        self.name = name
        self.date = date                
        self.creator = creator
        self.segments = []
        self.albums = []
    }
    
    func addSegment(tripSegment: TripSegment) {
        self.segments?.append(tripSegment)
    }
    
    func insertSegment(tripSegment: TripSegment,  atIndex index: Int) {
        self.segments?.insert(tripSegment, at: index)
    }
    
    class func parseClassName() -> String {
        return "Trip"
    }

}

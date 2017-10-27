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
    @NSManaged var tripDescription: String?
    @NSManaged var date: Date?
    @NSManaged var segments: [TripSegment]?
    @NSManaged var coverPhoto: PFFile?
    @NSManaged var albums: [Album]?
    @NSManaged var creator: PFUser
    
    override init() {
        super.init()
    }
    
    init(name: String, date: Date, creator: PFUser) {
        super.init()
        self.name = name
        self.tripDescription = ""
        self.date = date                
        self.creator = creator
        self.segments = []
        self.albums = []
    }
    
    static func createTrip(name: String, date: Date, creator: PFUser) -> Trip {
        let trip = Trip(name: name, date: date, creator: creator)
        let tripMember = TripMember(user: creator, isCreator:true, trip: trip)
        tripMember.saveInBackground()
        return trip
    }
    
    func setCoverPhoto(file: PFFile) {
        self.coverPhoto = file
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

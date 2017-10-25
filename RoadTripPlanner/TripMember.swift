//
//  TripMember.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/15/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse

enum InviteStatus {
    case Pending
    case Confirmed
    case Rejected
}

class TripMember: PFObject, PFSubclassing {

    @NSManaged var user: PFUser
    @NSManaged var trip: Trip
    @NSManaged var status: Int  // 0: Pending, 1: Confirmed, 2: Rejected
    
    override init() {
        super.init()
    }
    
    init(user: PFUser, trip: Trip) {
        super.init()
        self.user = user
        self.trip = trip
        self.status = InviteStatus.Pending.hashValue
    }
    
    func setStatus(status: InviteStatus) {
        self.status = status.hashValue
    }
    
    class func parseClassName() -> String {
        return "TripMember"
    }

}

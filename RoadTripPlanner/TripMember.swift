//
//  TripMember.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/15/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse

class TripMember: PFObject {

    @NSManaged var user: PFUser
    @NSManaged var status: Int  // 0: Pending, 1: Confirmed, 2: Rejected
    
    class func parseClassName() -> String {
        return "TripMember"
    }

}

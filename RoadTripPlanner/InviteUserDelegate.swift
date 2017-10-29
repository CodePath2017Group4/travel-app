//
//  InviteUserDelegate.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/28/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Foundation
import Parse

protocol InviteUserDelegate {
    func addInvitation(tripMember: TripMember)
}

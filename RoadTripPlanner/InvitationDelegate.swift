//
//  InvitationDelegate.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/28/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Foundation

protocol InvitationDelegate {
    func confirmInvitation(index: Int)
    
    func rejectInvitation(index: Int)
}


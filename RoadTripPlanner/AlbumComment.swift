//
//  AlbumComment.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/15/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse

class AlbumComment: PFObject {
    
    @NSManaged var user: PFUser
    @NSManaged var text: String?

    class func parseClassName() -> String {
        return "AlbumComment"
    }
}

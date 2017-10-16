//
//  Album.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Foundation
import Parse

class Album: PFObject, PFSubclassing {
    @NSManaged var albumName: String?
    @NSManaged var albumDescription: String?
    @NSManaged var tripName: String?
    @NSManaged var tripDate: String?
    @NSManaged var owner: String?    
    @NSManaged var comments: [AlbumComment]?
    @NSManaged var likes: [PFUser]
    @NSManaged var photos: [PFFile]
    
    init(albumName: String, tripName: String, tripDate: String, owner: String, photos: [PFFile]) {
        super.init()
        self.albumName = albumName
        self.tripName = tripName
        self.tripDate = tripDate
        self.owner = owner
        self.photos = photos
    }
    
    class func parseClassName() -> String {
        return "Album"
    }
}

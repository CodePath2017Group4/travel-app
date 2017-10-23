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
    @NSManaged var owner: PFUser?
    @NSManaged var trip: Trip?
    
    @NSManaged var comments: [AlbumComment]?
    @NSManaged var likes: [PFUser]
    @NSManaged var photos: [PFFile]
    
    override init() {
        super.init()
    }
    
    init(albumName: String, albumDescription: String, trip: Trip, owner: PFUser) {
        super.init()
        self.albumName = albumName
        self.albumDescription = albumDescription
        self.trip = trip
        self.owner = owner
        
        self.photos = []
        self.likes = []
        self.comments = []
    }
    
    func updated(copyFrom: Album) {
        self.albumName = copyFrom.albumName
        self.albumDescription = copyFrom.albumDescription
        self.trip = copyFrom.trip
        self.owner = copyFrom.owner
        
        self.photos = copyFrom.photos
        self.likes = copyFrom.likes
        self.comments = copyFrom.comments
    }
    
    class func parseClassName() -> String {
        return "Album"
    }
}

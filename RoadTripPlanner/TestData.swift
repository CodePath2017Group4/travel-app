//
//  TestData.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/21/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class TestData : NSObject{
    
    private let appleGeoPoint = PFGeoPoint(latitude: 37.3316756, longitude: -122.032383)
    private let facebookGeoPoint = PFGeoPoint(latitude: 37.4845317, longitude: -122.1496421)
    private let ghiradelliGeoPoint = PFGeoPoint(latitude: 37.8058763, longitude: -122.4251442)
    private let harrisRanchGeoPoint = PFGeoPoint(latitude: 36.2536897, longitude: -120.2395319)
    private let universalStudiosGeoPoint = PFGeoPoint(latitude: 34.1381168, longitude: -118.3555723)
    private let santaMonicaGeoPoint = PFGeoPoint(latitude: 34.0091821, longitude: -118.4936843)
    
    var trips: [Trip] = []
    
    override init() {
        
        // If we do not have a current user, skip out
        guard let user = PFUser.current() else { return }
        
        let trip = Trip(name: "Road Trip SF", date: Date(), creator: user)
        
        trip.addSegment(tripSegment: TripSegment(name: "Apple Infinite Loop", address: "1 Infinite Loop, Cupertino, CA 95014", geoPoint: appleGeoPoint))
        trip.addSegment(tripSegment: TripSegment(name: "Facebook Headquarters", address: "1 Hacker Way, Menlo Park, CA 94025", geoPoint: facebookGeoPoint))
        trip.addSegment(tripSegment: TripSegment(name: "Ghirardelli Square", address: "North Point Street, San Francisco, CA", geoPoint: ghiradelliGeoPoint))
        
        trips.append(trip)
        
        let trip2 = Trip(name: "Los Angeles Trip", date: Date(), creator: user)
        trip2.addSegment(tripSegment: TripSegment(name: "Ghirardelli Square",
                                                  address: "North Point Street, San Francisco, CA",
                                                  geoPoint: ghiradelliGeoPoint))
        trip2.addSegment(tripSegment: TripSegment(name: "Harris Ranch Inn & Restaurant",
                                                  address: "24505 W Dorris Ave, Coalinga, CA 93210",
                                                  geoPoint: harrisRanchGeoPoint))
        trip2.addSegment(tripSegment: TripSegment(name: "Universal Studios Hollywood",
                                                  address: "100 Universal City Plaza, Universal City, CA 91608",
                                                  geoPoint: universalStudiosGeoPoint))
        trip2.addSegment(tripSegment: TripSegment(name: "Loews Santa Monica Beach Hotel",
                                                  address: "1700 Ocean Ave, Santa Monica, CA 90401",
                                                  geoPoint: santaMonicaGeoPoint))
        
        trips.append(trip2)
    }
}

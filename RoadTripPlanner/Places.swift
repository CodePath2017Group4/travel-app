//
//  Places.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/24/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import CoreLocation

final class Places {
    
    var title: String?
    var cllocation: CLLocation
    var regionRadius: Double
    var location: String?
    var type: String?
    var distance : Double?
    var coordinate : CLLocationCoordinate2D
    
    init(cllocation: CLLocation, distance:Double!, coordinate: CLLocationCoordinate2D) {
        
        self.title = "title"
        self.cllocation = cllocation
        self.coordinate = coordinate
        self.regionRadius = 0.0
        self.location = "location"
        self.type = "type"
        self.distance = distance
    }
    
    
    // Function to calculate the distance from given location.
    func calculateDistance(fromLocation: CLLocation?) {
        
        distance = cllocation.distance(from: fromLocation!)
    }
}




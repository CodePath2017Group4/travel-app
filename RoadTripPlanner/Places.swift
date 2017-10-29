//
//  Places.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/24/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Contacts


final class Places: NSObject, MKAnnotation {
    
    var title: String?
    var cllocation: CLLocation
    var regionRadius: Double
    var location: String?
    var type: String?
    var distance : Double?
    var coordinate : CLLocationCoordinate2D
    
    init(title: String, location: String, type: String, cllocation: CLLocation, distance: Double!, coordinate: CLLocationCoordinate2D) {
        
        self.title = title//"title"
        self.cllocation = cllocation
        self.coordinate = coordinate
        self.regionRadius = 0.0
        self.location = location//"location"
        self.type = type//"type"
        self.distance = distance
    }
    
    init(cllocation: CLLocation, distance: Double!, coordinate: CLLocationCoordinate2D) {
        
        self.title = "title"
        self.cllocation = cllocation
        self.coordinate = coordinate
        self.regionRadius = 0.0
        self.location = "location"
        self.type = "type"
        self.distance = distance
    }
    
    var subtitle: String? {
        return location//locationName
    }
    
    var imageName: String? {
        if type == "start" { return "startflag" }
        else if type == "finish" { return "finishflag" }
        else if type == "restaurants" || type == "food, restaurant" { return "food30" }
        else if type == "auto" { return "gasstation30" }
        else { return "custommarker" }
    }
    
    // Function to calculate the distance from given location.
    func calculateDistance(fromLocation: CLLocation?) {
        
        distance = cllocation.distance(from: fromLocation!)
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    var markerTintColor: UIColor  {
        switch type {//discipline {
        case "auto"?:
            return .orange
        case "entertaintment"?:
            return .purple
        case "hotels"?:
            return .blue
        case "restaurants"?, "food, restaurant"?:
            return UIColor(red: 22/255, green: 134/255, blue: 36/255, alpha: 1)//.green
        case "arts"?:
            return .cyan
        case "publicservicesgovt"?:
            return .yellow
        default:
            return .purple
        }
    }

}




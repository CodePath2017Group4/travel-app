//
//  Utils.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Foundation
import MapKit
import Parse

class Utils {
    class func formatDate(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(month)/\(day)/\(year)"
    }
    
    class func tripSegmentFromMapItem(mapItem: MKMapItem) -> TripSegment {
        
        let placemark = mapItem.placemark
        let name = placemark.name ?? mapItem.name ?? ""
        let locality = placemark.locality ?? ""
        let administrativeArea = placemark.administrativeArea ?? ""  // state
        let postalCode = placemark.postalCode ?? ""
        let isoCountryCode = placemark.isoCountryCode ?? ""
        let address = "\(name), \(locality), \(administrativeArea) \(postalCode), \(isoCountryCode)"
        
        log.info(name)
        log.info(address)
        
        let geoPoint = PFGeoPoint(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        
        let tripSegment = TripSegment(name: name, address: address, geoPoint: geoPoint)
        return tripSegment
    }
}

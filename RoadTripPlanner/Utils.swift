//
//  Utils.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Foundation
import Parse
import UIKit
import MapKit

class Utils {
    class func formatDate(date: Date?) -> String {
        
        guard let date = date else { return "" }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(month)/\(day)/\(year)"
    }
    
    class func roundImageCorner(image: UIImageView) {
        image.layer.cornerRadius = image.frame.height / 2
    }
    
    class func imageToFile(image: UIImage) -> PFFile? {
        let data = UIImageJPEGRepresentation(image, 0.7)
        return PFFile(data: data!)
    }
    
    class func fileToImage(file: PFFile, callback: @escaping (UIImage) -> Void) {
        file.getDataInBackground(block: { (data, error) -> Void in
            if (error == nil) {
                if let data = data {
                    callback(UIImage(data: data)!)
                }
            }
        })
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

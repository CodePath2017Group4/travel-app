//
//  PlacesMarkerView.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/28/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import MapKit

class PlacesMarkerView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        
        willSet {
            print("entered PlacesMarkerView =========>>   willset")

            print("newValue \(newValue)")
            guard let places = newValue as? Places else { return }
            
            print("entered PlacesMarkerView =========>>   annotation")
            print("entered type =========>>   \(places.type!)")

            print("entered type condition =========>>   \((places.type != "start" && places.type != "finish"))")

            canShowCallout = (places.type != "start" && places.type != "finish")//true
            
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            markerTintColor = places.markerTintColor
            if (places.type != "start" && places.type != "finish") {
                glyphText = "\((places.type?.capitalized.first)!)"
                print("glyphText \(glyphText)")

            }
            else {
                if let imageName = places.imageName {
                    glyphImage = UIImage(named: imageName)
                } else {
                    glyphImage = nil
                }
            }
        }
    }

}

class PlaceMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        
        willSet {
            
            guard let places = newValue as? Places else { return }
            
            canShowCallout = (places.type != "start" && places.type != "finish")//true
            
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "navigation"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.textColor = places.markerTintColor
            detailLabel.text = places.subtitle

            detailCalloutAccessoryView = detailLabel
            
            markerTintColor = places.markerTintColor
            
            if let imageName = places.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        
        }
    }
    
    
}

class PlacesView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let places = newValue as? Places else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = places.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
}

//
//  MapViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/11/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate var center: CLLocationCoordinate2D!
    fileprivate var annotations:   [MKPointAnnotation]!
    
    fileprivate let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
   lazy var locationManager: CLLocationManager = self.makeLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView.delegate = self
        mapView.tintColor = UIColor.blue.withAlphaComponent(0.7)


        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: centerLocation.coordinate.latitude, longitude: centerLocation.coordinate.longitude)
        
        annotation.coordinate = coordinate
        goToLocation(location: centerLocation)
    
    }

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    private func makeLocationManager() -> CLLocationManager {
        var locationManager = CLLocationManager()
        locationManager = CLLocationManager()
        //locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }
}


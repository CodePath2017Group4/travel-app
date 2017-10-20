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
    
    var startMapItem: MKMapItem?
    var destMapItem: MKMapItem?
    
    fileprivate var center: CLLocationCoordinate2D!
    fileprivate var annotations:   [MKPointAnnotation]!
    
    fileprivate let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
    lazy var locationManager: CLLocationManager = self.makeLocationManager()
    
    fileprivate var route: MKRoute!
    
    static func storyboardInstance() -> MapViewController? {
        let storyboard = UIStoryboard(name: "MapViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? MapViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.tintColor = UIColor.blue.withAlphaComponent(0.7)
        mapView.delegate = self
        
        let startPoint = MKPointAnnotation()
        let destPoint = MKPointAnnotation()
        
        startPoint.coordinate = (startMapItem?.placemark.coordinate)!
        startPoint.title = "Start"
        mapView.addAnnotation(startPoint)
        
        destPoint.coordinate = (destMapItem?.placemark.coordinate)!
        destPoint.title = "End"
        mapView.addAnnotation(destPoint)
        
//        let annotation = MKPointAnnotation()
//        let coordinate = CLLocationCoordinate2D(latitude: centerLocation.coordinate.latitude, longitude: centerLocation.coordinate.longitude)
//
//        annotation.coordinate = coordinate
//        goToLocation(location: centerLocation)
        
        mapView.centerCoordinate = destPoint.coordinate
    
        // Span of the map
        mapView.setRegion(MKCoordinateRegionMake(destPoint.coordinate, MKCoordinateSpanMake(0.7, 0.7)), animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = startMapItem
        directionsRequest.destination = destMapItem
        
        directionsRequest.transportType = .automobile
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            if error == nil {
                self.route = response!.routes.first
                self.mapView.add(self.route.polyline)
                
                let coordCount = self.route.polyline.coordinates.count
                log.info("coordinate count: \(coordCount)")
            }
        }
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

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let lineRenderer = MKPolylineRenderer(polyline: route.polyline)
        lineRenderer.strokeColor = UIColor.red
        lineRenderer.lineWidth = 2
        return lineRenderer
    }
}

extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D] (repeating: kCLLocationCoordinate2DInvalid, count: self.pointCount)
        
        self.getCoordinates(&coords, range: NSRange(location: 0, length: self.pointCount))
        
        return coords
    }
}


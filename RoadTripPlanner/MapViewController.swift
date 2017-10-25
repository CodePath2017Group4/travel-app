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
import YelpAPI

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var center: CLLocationCoordinate2D!
    fileprivate var annotations:   [MKPointAnnotation]!
    fileprivate let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
    lazy var locationManager: CLLocationManager = self.makeLocationManager()
    var businesses: [YLPBusiness]!
    var searchTerm: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        
        mapView.delegate = self
        mapView.tintColor = UIColor.blue.withAlphaComponent(0.7)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 133
        tableView.separatorStyle = .none
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: centerLocation.coordinate.latitude, longitude: centerLocation.coordinate.longitude)
        
        annotation.coordinate = coordinate
        goToLocation(location: centerLocation)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func registerForNotifications() {
        // Register to receive Businesses
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BussinessesDidUpdate"),
                                               object: nil, queue: OperationQueue.main) {
                                                [weak self] (notification: Notification) in
                                                self?.businesses = notification.userInfo!["businesses"] as! [YLPBusiness]
                                                self?.addAnnotationFor(businesses: (self?.businesses)!)
                                                self?.tableView.reloadData()
                                                self?.mapView.reloadInputViews()
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }
    
    func makeSpanRegion()
    {
        var miles: Double = 5.0
        
        /*if let distInMeters = filters[Constants.filterDistance] {
         var distInMiles = Double.init(distInMeters as! NSNumber) * 0.000621371
         distInMiles = rounded(no: distInMiles, toPlaces: 1)
         
         if distInMiles > miles {
         miles = distInMiles
         }
         }
         */
        print("miles \(miles)")
        
        let scalingFactor: Double = abs( (cos(2 * M_PI * centerLocation.coordinate.latitude / 360.0) ))
        
        var span: MKCoordinateSpan = MKCoordinateSpan.init()
        
        span.latitudeDelta = miles/69.0
        span.longitudeDelta = miles/(scalingFactor * 69.0)
        
        var region: MKCoordinateRegion = MKCoordinateRegion.init()
        region.span = span
        region.center = centerLocation.coordinate
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func rounded(no : Double, toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (no * divisor).rounded() / divisor
    }
    
    
    
}


// MARK: - Map View Delegate methods

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID) // customize the annotion view
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
            //if searchTerm == "gas" {
                annotationView?.image = UIImage(named: "gas.png")
           // }
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let index = (self.annotations as NSArray).index(of: view.annotation)
        
        if index >= 0 {
            self.showDetailsFor(self.businesses[index] )
        }
    }
    func showDetailsFor(_ business: YLPBusiness) {
        
        /*let storyboard = UIStoryboard(name: Constants.main, bundle: Bundle.main)
         
         let controller = storyboard.instantiateViewController(withIdentifier: Constants.detailsReuseIdentifier) as! DetailViewController
         controller.business = business
         //controller.filters = filters
         
         self.navigationController?.pushViewController(controller, animated: true)*/
       
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if self.center == nil {
            self.center = mapView.region.center
        } else {
            let before = CLLocation(latitude: self.center.latitude, longitude: self.center.longitude)
            let nowCenter = mapView.region.center
            let now = CLLocation(latitude: nowCenter.latitude, longitude: nowCenter.longitude)
        }
    }
}

// MARK: - Location Manager Delegate methods

extension MapViewController: CLLocationManagerDelegate {
    
    func addAnnotationFor(businesses: [YLPBusiness]) {
        print("addAnnotationFor")
        makeSpanRegion()
        
        self.annotations = []
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if(businesses != nil) {
            for business in businesses {
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: (business.location.coordinate?.latitude)!, longitude: (business.location.coordinate?.longitude)!)
                annotation.coordinate = coordinate
                annotation.title = business.name
                annotation.subtitle = business.identifier
                self.annotations.append(annotation)
            }
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    
}

extension MapViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        print("businesses.countin table cellfor row \(businesses)")
        cell.businesses = businesses
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked table cell a indexpath \(indexPath.row)")
        
    }
    
}


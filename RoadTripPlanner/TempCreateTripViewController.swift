//
//  TempCreateTripViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TempCreateTripViewController: UIViewController {

    @IBOutlet weak var currentLocationTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    var results: NSArray = []
    
    let locationManager = CLLocationManager()
    var localSearch: MKLocalSearch?
    var userCoordinate: CLLocationCoordinate2D!
    
    static func storyboardInstance() -> TempCreateTripViewController? {
        let storyboard = UIStoryboard(name: "TempCreateTripViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? TempCreateTripViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTableView.dataSource = self
        locationTableView.delegate = self
        
        locationManager.delegate = self
        
        // Initialize the location tuples
        locationTuples = [(currentLocationTextField, nil), (destinationTextField, nil)]
        
        // Ask for authorization to access the user's location.
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func startSearch(searchString: String) {
        
        var region = MKCoordinateRegion()
        region.center.latitude = self.userCoordinate.latitude
        region.center.longitude = self.userCoordinate.longitude
    }
    
    fileprivate func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
}

extension TempCreateTripViewController : UITableViewDelegate {
    
}

extension TempCreateTripViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        cell.location = results[(indexPath as NSIndexPath).row] as! NSDictionary
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This is the selected venue
        let venue = results[(indexPath as NSIndexPath).row] as! NSDictionary
        
        let lat = venue.value(forKeyPath: "location.lat") as! NSNumber
        let lng = venue.value(forKeyPath: "location.lng") as! NSNumber
        
        let latString = "\(lat)"
        let lngString = "\(lng)"
        
        print(latString + " " + lngString)
        
    }
}

extension TempCreateTripViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        self.userCoordinate = (userLocation?.coordinate)!
        
        // Reverse geocode the location
        CLGeocoder().reverseGeocodeLocation(userLocation!) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let placemarks = placemarks {
                let placemark = placemarks.first!
                let mapPlacemark = MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String:Any]?)
                let mapItem = MKMapItem(placemark: mapPlacemark)
                
                self.locationTuples[0].mapItem = mapItem
                
                self.currentLocationTextField.text = self.formatAddressFromPlacemark(placemark: placemark)
            }
        }
        
        // We only want one update
        manager.stopUpdatingLocation()
        
        // Remove the delegate to prevent updating again.
        manager.delegate = nil
        
        // We have a location now..
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("location manager error: \(error)")
    }
}




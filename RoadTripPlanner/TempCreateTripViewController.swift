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
import Parse

class TempCreateTripViewController: UIViewController {

    @IBOutlet weak var currentLocationTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var startTripButton: UIButton!
    
    var selectedCategory: PlaceCategory?
    
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    var places = [MKMapItem]()
    
    let locationManager = CLLocationManager()
    
    // Search completion
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    static func storyboardInstance() -> TempCreateTripViewController? {
        let storyboard = UIStoryboard(name: "TempCreateTripViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? TempCreateTripViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
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
     
        categoriesView.isHidden = true
        startTripButton.layer.cornerRadius = 5
        
        destinationTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        
        let name = placemark.name ?? ""
        let locality = placemark.locality ?? ""
        let administrativeArea = placemark.administrativeArea ?? ""  // state
        let postalCode = placemark.postalCode ?? ""
        let isoCountryCode = placemark.isoCountryCode ?? ""
        
        let address = "\(name), \(locality), \(administrativeArea) \(postalCode), \(isoCountryCode)"
        log.info(address)
        
        return address
    }
    
    fileprivate func tripSegmentPointFromLocation(location: CLLocation, completion: @escaping (TripSegmentPoint?, Error?) -> Void) {
    
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let placemarks = placemarks {
                let placemark = placemarks.first!
                let name = placemark.name ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""  // state
                let postalCode = placemark.postalCode ?? ""
                let isoCountryCode = placemark.isoCountryCode ?? ""
    
                let address = "\(locality), \(administrativeArea) \(postalCode), \(isoCountryCode)"
    
                log.verbose("name: \(name), address: \(address)")
    
                let tripSegmentPoint = TripSegmentPoint(name: name, address: address, geoPoint: PFGeoPoint(location: location))
                completion(tripSegmentPoint, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    @IBAction func startTripButtonPressed(_ sender: Any) {
        
        // Create a new trip object and save it to the database
        
        let startLocation = locationTuples[0].mapItem?.placemark.location
        var startSegmentPoint: TripSegmentPoint?
        var destSegmentPoint: TripSegmentPoint?
        tripSegmentPointFromLocation(location: startLocation!) { (tripSegmentPoint, error) in
            if error == nil {
                startSegmentPoint = tripSegmentPoint!
            }
        }
        
        let destLocation = locationTuples[1].mapItem?.placemark.location
        tripSegmentPointFromLocation(location: destLocation!) { (tripSegmentPoint, error) in
            if error == nil {
                destSegmentPoint = tripSegmentPoint!
            }
        }
        
        //37.21841670,-121.87007890
        // latitude: 35.373404999999998, longitude: -119.018911  - Bakersfield
        // latitude: 34.054124700000003, longitude: -118.2433624 - Los Angeles
        
        let tempSegment = TripSegmentPoint(name: "Temp", address: "Temp Address", geoPoint: PFGeoPoint(location: startLocation))
        
        let trip = Trip(name: (locationTuples[1].textField?.text)!, date: Date(), startPoint: tempSegment, destinationPoint: tempSegment, creator: PFUser.current()!)
//
//        let intermediateLocation = CLLocation(latitude: 35.373404999999998, longitude: -119.018911)
//        var intermediatePoint: TripSegmentPoint?
//        tripSegmentPointFromLocation(location: intermediateLocation) { (tripSegmentPoint, error) in
//            if error == nil {
//                intermediatePoint = tripSegmentPoint!
//                trip.addSegmentPoint(segmentPoint: intermediatePoint!)
//            }
//        }
        
        
        
        
//        trip.saveInBackground { (success, error) in
//            if (success) {
//                log.info("trip saved")
//            } else {
//                log.error(error?.localizedDescription ?? "Uknown Error")
//            }
//        }
        
        YelpFusionClient.sharedInstance.search(withLocation: startLocation!, term: "automotive", categories: ["servicestations", "evchargingstations"])
        
        
//        // Push the MapViewController onto the nav stack.
//        guard let mapVC = MapViewController.storyboardInstance() else { return }
//        mapVC.startMapItem = locationTuples[0].mapItem
//        mapVC.destMapItem = locationTuples[1].mapItem
//        navigationController?.pushViewController(mapVC, animated: true)
        
        // Push the TripDetailsViewController onto the nav stack.
        guard let tripDetailsVC = TripDetailsViewController.storyboardInstance() else { return }
        tripDetailsVC.trip = trip
        navigationController?.pushViewController(tripDetailsVC, animated: true)
        
    }
    
    fileprivate func yelpLookupFromPlacemark(placemark: CLPlacemark, term: String) {
        YelpFusionClient.sharedInstance.search(withLocationName: placemark.name!, term: term)
    }
    
    
}

extension TempCreateTripViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        locationTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        log.error(error)
    }
}

extension TempCreateTripViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        log.verbose(textField.text ?? "")
        searchCompleter.queryFragment = textField.text!
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TempCreateTripViewController : UITableViewDelegate {
    
}

extension TempCreateTripViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        // Update the destination text field
        destinationTextField.text = completion.title
        // Hide the table view and show the categories view
        categoriesView.isHidden = false
        locationTableView.isHidden = true
        
        search.start { (response: MKLocalSearchResponse?, error: Error?) in
            if response != nil {
                guard let response = response else {
                    return
                }
                let coordinate = response.mapItems.first?.placemark.coordinate
                log.verbose(String(describing: coordinate))
                let placemark = response.mapItems.first?.placemark
                let mapItem = MKMapItem(placemark: placemark!)
                self.locationTuples[1].mapItem = mapItem
            }
        }
        
    }
}

extension TempCreateTripViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        // Reverse geocode the user's location to obtain the address
        CLGeocoder().reverseGeocodeLocation(userLocation!) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let placemarks = placemarks {
                let placemark = placemarks.first!
                
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String:Any]?))
                
                log.verbose(mapItem)
                
                self.locationTuples[0].mapItem = mapItem
                self.currentLocationTextField.text = self.formatAddressFromPlacemark(placemark: placemark)
            }
        }
        
        // We only want one update
        manager.stopUpdatingLocation()
        
        // Remove the delegate to prevent updating again.
        manager.delegate = nil
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("location manager error: \(error)")
    }
}




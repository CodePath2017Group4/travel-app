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
        
        search.start { (response: MKLocalSearchResponse?, error: Error?) in
            if response != nil {
                guard let response = response else {
                    return
                }
                let coordinate = response.mapItems.first?.placemark.coordinate
                log.verbose(String(describing: coordinate))
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
                let mapPlacemark = MKPlacemark(coordinate: placemark.location!.coordinate)
                let mapItem = MKMapItem(placemark: mapPlacemark)
                
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




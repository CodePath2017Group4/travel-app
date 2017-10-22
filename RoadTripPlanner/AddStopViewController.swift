//
//  AddStopViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/22/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class AddStopViewController: UIViewController {

    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    // Search completion
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    static func storyboardInstance() -> AddStopViewController? {
        let storyboard = UIStoryboard(name: "AddStopViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? AddStopViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        locationManager.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AddStopViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        log.error(error)
    }
}

extension AddStopViewController : UITextFieldDelegate {
    
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

extension AddStopViewController : UITableViewDelegate {
    
}

extension AddStopViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResultCell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.LocationSearchResultCell, for: indexPath) as! LocationSearchResultCell
        searchResultCell.searchCompletionResult = searchResults[indexPath.row]
        
        return searchResultCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response: MKLocalSearchResponse?, error: Error?) in
            if response != nil {
                guard let response = response else {
                    return
                }
                let coordinate = response.mapItems.first?.placemark.coordinate
                log.verbose(String(describing: coordinate))
                let placemark = response.mapItems.first?.placemark
                let mapItem = MKMapItem(placemark: placemark!)
                
                
            }
        }
        
    }
}

extension AddStopViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        // Reverse geocode the user's location to obtain the address
        CLGeocoder().reverseGeocodeLocation(userLocation!) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let placemarks = placemarks {
                let placemark = placemarks.first!
                
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String:Any]?))
                
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





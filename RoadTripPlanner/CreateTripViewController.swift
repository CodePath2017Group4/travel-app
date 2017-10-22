//
//  CreateTripViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import DatePickerDialog
import CoreLocation
import MapKit
import YelpAPI
import Parse

class CreateTripViewController: UIViewController {
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var createTripButton: UIButton!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var autoImageView: UIImageView!
    
    @IBOutlet weak var autoSubView: UIView!
    @IBOutlet weak var autoBackImageView: UIImageView!
    @IBOutlet weak var allAutoImageView: UIImageView!
    @IBOutlet weak var gasImageView : UIImageView!
    @IBOutlet weak var parkingImageView: UIImageView!
    @IBOutlet weak var chargingImageView: UIImageView!
   
    fileprivate var isAutoSubViewOpen = false
    
    let autoCategoriesList = ["back", "all", "servicestations", "autoelectric", "parking"]//"gas", "charging","parking"]
    var selectedTypes: [String]!

    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    let locationManager = CLLocationManager()
    
    var locationsArray: [(textField: UITextField?, mapItem: MKMapItem?)] {
        var filtered = locationTuples.filter({ $0.mapItem != nil })
        //filtered += [filtered.first!] //Round trip
        return filtered
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startTextField.tag = 1
        destinationTextField.tag = 2
        
        let startLeftViewLabel = UILabel.init(frame: CGRect(x:0,y:0,width:50, height:21))
        var attributedString = NSAttributedString(string: "  From :", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : UIColor.lightGray])
        startLeftViewLabel.attributedText = attributedString
        startTextField.leftView = startLeftViewLabel
        startTextField.leftViewMode = .always
        
        let toLeftViewLabel = UILabel.init(frame: CGRect(x:0,y:0,width:50, height:21))
        attributedString = NSAttributedString(string: "      To  :", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : UIColor.lightGray])
        toLeftViewLabel.attributedText = attributedString
        destinationTextField.leftView = toLeftViewLabel
        destinationTextField.leftViewMode = .always

        startTextField.delegate = self
        destinationTextField.delegate = self
        
        getLocation()
        
        locationTuples = [(startTextField, nil), (destinationTextField, nil)]

        createTripButton.layer.cornerRadius = createTripButton.frame.height / 2
        autoSubView.isHidden = true
        
        let dateImageTap = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        dateImageTap.numberOfTapsRequired = 1
        dateImageView.isUserInteractionEnabled = true
        dateImageView.addGestureRecognizer(dateImageTap)
        
        
        let clockImageTap = UITapGestureRecognizer(target: self, action: #selector(clockTapped))
        clockImageTap.numberOfTapsRequired = 1
        clockImageView.isUserInteractionEnabled = true
        clockImageView.addGestureRecognizer(clockImageTap)
        self.navigationController?.navigationBar.isHidden = false
        
        // Main Category
        let autoImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        autoImageTap.numberOfTapsRequired = 1
        autoImageView.isUserInteractionEnabled = true
        autoImageView.tag = 0
        autoImageView.addGestureRecognizer(autoImageTap)
        
        // Auto Subcategory
        let backAutoImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        backAutoImageTap.numberOfTapsRequired = 1
        autoBackImageView.isUserInteractionEnabled = true
        autoBackImageView.tag = 0
        autoBackImageView.addGestureRecognizer(backAutoImageTap)
        
        let allAutoImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        allAutoImageTap.numberOfTapsRequired = 1
        allAutoImageView.isUserInteractionEnabled = true
        allAutoImageView.tag = 1
        allAutoImageView.addGestureRecognizer(allAutoImageTap)
        
        let gasImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        gasImageTap.numberOfTapsRequired = 1
        gasImageView.isUserInteractionEnabled = true
        gasImageView.tag = 2
        gasImageView.addGestureRecognizer(gasImageTap)
        
        let chargingImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        chargingImageTap.numberOfTapsRequired = 1
        chargingImageView.isUserInteractionEnabled = true
        chargingImageView.tag = 3
        chargingImageView.addGestureRecognizer(chargingImageTap)
        
        let parkingImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        parkingImageTap.numberOfTapsRequired = 1
        parkingImageView.isUserInteractionEnabled = true
        parkingImageView.tag = 4
        parkingImageView.addGestureRecognizer(parkingImageTap)
        
       
        if(selectedTypes == nil) {
            selectedTypes = [String]()
        }
    }
    
    @IBAction func swapFields(_ sender: Any) {
        swap(&startTextField.text, &destinationTextField.text)
        swap(&locationTuples[0].mapItem, &locationTuples[1].mapItem)
    }
    
    func categoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag

        if autoImageView.tag == selectedIndex {
            
            self.view.setNeedsUpdateConstraints()
            isAutoSubViewOpen = !isAutoSubViewOpen
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = true
                self.autoSubView.isHidden = false
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func autoSubCategoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        print("selectedIndex  \(selectedIndex)")
        
        let selectedImg = sender.view
        
        if selectedIndex! != 0 && selectedIndex! != 1 {
            
            if !selectedTypes.contains(autoCategoriesList[selectedIndex!]) {
                selectedTypes.append(autoCategoriesList[selectedIndex!])
                print("selectedTypes in if ===== >  \(selectedTypes)")
            }
        }
        else {
            if selectedIndex == 1 {
                selectedTypes.removeAll()
                selectedTypes.append(autoCategoriesList[selectedIndex!])
            }
          
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 1) {
                    self.categoryView.isHidden = false
                    self.autoSubView.isHidden = true
                    self.view.layoutIfNeeded()
                
            }
        }
    }


    func dateTapped(_ sender: AnyObject) {
        DatePickerDialog(showCancelButton: false).show("Select Travel Date", doneButtonTitle: "Done", datePickerMode: .date) {

            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.dateLabel.text = formatter.string(from: dt)
            }
        }
        
    }
    
    func clockTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func onStartTrip(_ sender: Any) {
        performSearch(selectedTypes)
    }
    
    final func performSearch(_ term: [String]?) {
        print("term --- \(term)")
        /*if /*term != nil,*/ !(term?.isEmpty)! {
            
            
            var searchTerm = Category().constructSearchTerm("auto", term!)
            print("searchTerm --- \(searchTerm)")

            YelpFusionClient.sharedInstance.search(inCurrent: (locationManager.location?.coordinate)!, term: searchTerm, completionHandler:  { (businesses: [YLPBusiness]?, error: Error?) -> Void in
                
              //  self.businesses = businesses
                print("self.businesse -----\(businesses?.count)")
                
            })
            /*YelpFusionClient.sharedInstance.search(withLocation : "san francisco", term: term, completionHandler:  { (businesses: [YLPBusiness]?, error: Error?) -> Void in
             
             self.businesses = businesses
             print("self.businesse -----\(self.businesses.count)")
             
             //self.tableView.reloadData()
             
             })*/
        }
        else {
            
            /* Business.searchWithTerm(term: Constants.restaurants, completion: { (businesses: [Business]?, error: Error?) -> Void in
             
             self.businesses = businesses
             self.tableView.reloadData()
             
             })*/
        }*/
        
    }
    
    func showAddressTable(addresses: [String], textField: UITextField, placemarks: [CLPlacemark]) {
        
        let addressTableView = AddressTableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        addressTableView.addresses = addresses
        addressTableView.currentTextField = textField
        addressTableView.placemarkArray = placemarks
        addressTableView.mainViewController = self
        addressTableView.delegate = addressTableView
        addressTableView.dataSource = addressTableView
        view.addSubview(addressTableView)
    }
    
    fileprivate func tripSegmentFromMapItem(mapItem: MKMapItem) -> TripSegment {
        
        let placemark = mapItem.placemark
        let name = placemark.name ?? mapItem.name ?? ""
        let locality = placemark.locality ?? ""
        let administrativeArea = placemark.administrativeArea ?? ""  // state
        let postalCode = placemark.postalCode ?? ""
        let isoCountryCode = placemark.isoCountryCode ?? ""
        let address = "\(name), \(locality), \(administrativeArea) \(postalCode), \(isoCountryCode)"
        
        log.info(address)
        
        let geoPoint = PFGeoPoint(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        
        let tripSegment = TripSegment(name: name, address: address, geoPoint: geoPoint)
        return tripSegment
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue.identifier \(segue.identifier!)")
        
        if segue.identifier! == "StartTrip" {
            
            // Create a new trip object and save it to the database
            let startSegment = tripSegmentFromMapItem(mapItem: locationTuples[0].mapItem!)
            let destSegment = tripSegmentFromMapItem(mapItem: locationTuples[1].mapItem!)
            
            let trip = Trip(name: destSegment.name ?? "Unnamed Trip", date: Date(), creator: PFUser.current()!)
            trip.addSegment(tripSegment: startSegment)
            trip.addSegment(tripSegment: destSegment)
            
            trip.saveInBackground {
                (success, error) in
                if (success) {
                    log.info("trip saved")
                } else {
                    log.error(error?.localizedDescription ?? "Uknown Error")
                }
            }
            
            let routeMapViewController = segue.destination  as! RouteMapViewController
            routeMapViewController.locationArray = locationsArray
            routeMapViewController.trip  = trip
        }

       
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if locationTuples[0].mapItem == nil || locationTuples[1].mapItem == nil {
            showAlert("Please enter a valid starting point and at least one destination.")
            return false
        } else {
            return true
        }
    }
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. In order to use this app, " +
                    "go to Settings → Location and select the \"While Using " + "the App\" setting.")
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
    
    
    // MARK: - Utility methods
    // -----------------------
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
}

extension CreateTripViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    self.locationTuples[0].mapItem = MKMapItem(placemark:
                    MKPlacemark(coordinate: placemark.location!.coordinate,
                    addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
                                                   
                }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async() {
            self.showSimpleAlert(title: "Can't determine your location",
                                 message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
}

extension CreateTripViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        
        let currentTextField = locationTuples[textField.tag-1].textField
        let newPosition = currentTextField?.endOfDocument
        currentTextField?.selectedTextRange = currentTextField?.textRange(from: newPosition!, to: newPosition!)

        CLGeocoder().geocodeAddressString(currentTextField!.text!, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
                    if let placemarks = placemarks {
                        var addresses = [String]()
                        for placemark in placemarks {
                            print("placemark \(placemark)"); addresses.append(self.formatAddressFromPlacemark(placemark: placemark))
                        }
                                       
                        self.showAddressTable(addresses: addresses, textField: currentTextField!, placemarks: placemarks)
                    } else {
                        self.showAlert("Address not found.")

                    }
            })
    }
    
    func showAlert(_ alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel) {
            (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        
        locationTuples[textField.tag-1].mapItem = nil
        return true
    }
}

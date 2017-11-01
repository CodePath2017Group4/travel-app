//
//  CategoryListViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/11/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Parse
import YelpAPI
import MapKit


class CategoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [YLPBusiness]!
    var business: YLPBusiness!
    var selectedPlaces = [Places]()
    
    var locationArray: [(textField: UITextField?, mapItem: MKMapItem?)]!
    var termCategory: [String : [String]]!
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "listToMap" {

            let routeMapViewController = segue.destination as! RouteMapViewController
            
            routeMapViewController.placestops.append(contentsOf: selectedPlaces)
            routeMapViewController.businesses = businesses
            routeMapViewController.locationArray = locationArray
            routeMapViewController.trip  = trip
            routeMapViewController.termCategory  = termCategory
        }
    }
}

extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessListCell", for: indexPath) as! BusinessListCell
        tableView.separatorStyle = .none
        cell.selectionStyle = .none
        cell.business = businesses[indexPath.row]
        cell.delegate = self
        
        return cell
        
    }
}

extension CategoryListViewController: BusinessListCellDelegate {
    
    func businessListCell(businessListCell: BusinessListCell, didTapAddImage business: YLPBusiness) {
        
        let placestops = Places(title: business.name,
                                location: business.name,
                                type: business.categories[0].name, //need to address type later
                                cllocation: CLLocation.init(latitude: business.location.coordinate!.latitude, longitude: business.location.coordinate!.longitude),
                                distance: 0,
                                coordinate: CLLocationCoordinate2D(latitude: (business.location.coordinate?.latitude)!, longitude: (business.location.coordinate?.longitude)!))
        selectedPlaces.append(placestops)
        
    }
}


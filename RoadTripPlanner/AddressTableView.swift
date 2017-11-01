//
//  AddressTableView.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import MapKit

class AddressTableView: UITableView {

    var mainViewController: CreateTripViewController!
    var addresses: [String]!
    var placemarkArray: [CLPlacemark]!
    var currentTextField: UITextField!
    var sender: UIButton!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "AddressCell")
        self.tableFooterView = UIView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension AddressTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont(name: "HoeflerText-Black", size: 18)
        label.textAlignment = .center
        label.text = "Did you mean..."
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("addresses.count  \(addresses.count)")
        print("addresses \(addresses!)")
        print("row \(indexPath.row)")
        print("addresses \(addresses![0])")
        print("currentTextField \(currentTextField)")
        print("placemarkArray \(placemarkArray.count)")
        print("placemarkArray \(placemarkArray)")

        if addresses.count > indexPath.row {
            currentTextField.text = addresses![indexPath.row]
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemarkArray[indexPath.row].location!.coordinate, addressDictionary: placemarkArray[indexPath.row].addressDictionary as! [String:AnyObject]?))
            mainViewController.locationTuples[currentTextField.tag-1].mapItem = mapItem
        }
        removeFromSuperview()
    }
}

extension AddressTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as UITableViewCell!
        cell?.textLabel?.numberOfLines = 3
        cell?.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 15)
        
        if addresses.count > indexPath.row {
            cell?.textLabel?.text = addresses[indexPath.row]
        } else {
            cell?.textLabel?.text = "None of the above"
        }
        return cell!
    }
}


//
//  InviteToTripViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/28/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Parse
import UIKit

class InviteToTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tripTable: UITableView!
    
    var trips: [Trip] = []
    var delegate: InviteUserDelegate? = nil
    
    static func storyboardInstance() -> InviteToTripViewController? {
        let storyboard = UIStoryboard(name: "InviteToTripViewController", bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: "InviteToTripViewController") as? InviteToTripViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarDarkTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarDarkTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.title = "Select trip"
        tripTable.delegate = self
        tripTable.dataSource = self
        requestTrips()
        // Do any additional setup after loading the view.
    }
    
    private func requestTrips() {
        if let user = PFUser.current() {
            ParseBackend.getTripsCreatedByUser(user: user) {
                (trips, error) in
                if let trips = trips {
                    self.trips = trips
                    DispatchQueue.main.async {
                        self.tripTable.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripSummaryCell
        cell.setTrip(trip: self.trips[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = self.trips[indexPath.row]
        ParseBackend.getTripMemberOnTrips(trips: [trip], excludeCreator: false) {
            (tripMember, error) in
            if let tripMember = tripMember {
                if let vc = FriendsListViewController.storyboardInstance() {
                    vc.knownTripMember = tripMember
                    vc.trip = trip
                    vc.delegate = self.delegate
                    self.show(vc, sender: self)
                }
            } else {
                print("Error to get trip members: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

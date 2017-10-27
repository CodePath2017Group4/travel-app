//
//  FriendsListViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/23/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import Parse

class FriendsListViewController: UIViewController {

    static func storyboardInstance() -> FriendsListViewController? {
        let storyboard = UIStoryboard(name: "FriendsListViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? FriendsListViewController
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var trip: Trip?
    var friends = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.ViewBackgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80

        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarLightTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarLightTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Add Friends To Trip"
        
        searchBar.tintColor = Constants.Colors.NavigationBarLightTintColor
        
        ParseBackend.getUsers { (users, error) in
            if error == nil {
                for user in users! {
                    log.info(user.username!)
                }
                self.friends = users!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                log.error(error!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.FriendUserCell, for: indexPath) as! FriendUserCell
        cell.user = friends[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add selected user to the trip
        guard let trip = self.trip else {
            log.info("No trip to add friends to")
            return
        }
        
        let selectedUser = friends[indexPath.row]

        let tripMember = TripMember(user: selectedUser, isCreator: false, trip: trip)
        tripMember.saveInBackground(block: { (success, error) in
            if (error != nil) {
                log.error(error!)
                
            }
        })
        
//        ParseBackend.getTripsCreatedByUser(user: selectedUser) { (trips, error) in
//            if (error == nil) {
//                log.info("\(selectedUser.username ?? "") has created \(trips!.count) trips.")
//                for trip in trips! {
//                    log.info(trip.name!)
//                    
//                    let members = trip.getTripMembers()
//                    log.info("There are \(members.count) members on this trip.")
//                    for m in members {
//                        m.fetchIfNeededInBackground(block: { (object: PFObject?, error: Error?) in
//                            let user = m.user
//                            user.fetchIfNeededInBackground(block: { (object: PFObject?, error: Error?) in
//                                log.info("\(m.user.username ?? "No name") has status \(m.status)")
//                            })
//                        })
//                        
//                        
//                    }
//                }
//            }
//        }
        
//        trip.saveInBackground { (success, error) in
//            if success {
//                log.info("Trip saved")
//            } else {
//                guard let error = error else {
//                    log.error("Unknown error occurred saving trip \(trip.name)")
//                    return
//                }
//                log.error("Error saving trip: \(error)")
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

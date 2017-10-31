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
    var knownTripMember: [TripMember] = []
    var friends: [(PFUser, TripMember?)] = []
    var selectedIndex: Int = -1
    var delegate: InviteUserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.ViewBackgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80

        navigationItem.title = "Invite Friends"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: .plain, target: self, action: #selector(inviteTapped))
        
        searchBar.tintColor = Constants.Colors.NavigationBarLightTintColor
        
        ParseBackend.getUsers { (users, error) in
            if error == nil {
                self.zipFriendsAndKnownUsers(users: users!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                log.error(error!)
            }
        }
    }
    
    private func zipFriendsAndKnownUsers(users: [PFUser]) {
        self.friends = []
        for user in users {
            var found: TripMember? = nil
            for curMember in self.knownTripMember {
                if (curMember.user.username == user.username) {
                    log.info("User is already on the trip!")
                    found = curMember
                }
            }
            self.friends.append((user, found))
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        navigationController?.navigationBar.tintColor = UIColor.white
//        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func inviteTapped(_ sender: Any) {
        // Add selected user to the trip
        guard let trip = self.trip else {
            log.info("No trip to add friends to")
            return
        }
        guard selectedIndex >= 0 else {
            log.info("No friend is selected")
            return
        }
        guard friends[self.selectedIndex].1 == nil else {
            log.info("User is already on the trip!")
            return
        }
        let selectedUser = friends[self.selectedIndex].0
        let tripMember = TripMember(user: selectedUser, isCreator: false, trip: trip)
        
        friends[self.selectedIndex].1 = tripMember
        if let delegate = self.delegate {
            delegate.addInvitation(tripMember: tripMember)
        }
        tripMember.saveInBackground(block: { (success, error) in
            if (error != nil) {
                log.error("Error inviting trip member: \(error!)")
            } else {
                log.info("TripMember invited")
            }
        })
        self.tableView.reloadData()
    }
}
extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.FriendUserCell, for: indexPath) as! FriendUserCell
        cell.user = friends[indexPath.row].0
        if let tripMember = friends[indexPath.row].1 {
            if (tripMember.isCreatingUser) {
                cell.setStatus(onTrip: InviteStatus.Confirmed.hashValue)
            } else {
                cell.setStatus(onTrip: tripMember.status)
            }
        } else {
            cell.setStatus(onTrip: -1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.selectedIndex >= 0) {
            tableView.deselectRow(at: IndexPath(row: self.selectedIndex, section: 0), animated: true)
        }
        self.selectedIndex = indexPath.row
    }

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

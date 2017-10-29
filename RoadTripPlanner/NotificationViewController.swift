//
//  NotificationViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/28/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Parse
import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InvitationDelegate {
    @IBOutlet weak var notificationTable: UITableView!
    
    let MAX_INVITATIONS: Int = 3
    
    var expandPending: Bool = true
    var expandPast: Bool = true
    
    var trips: [Trip] = []
    var pendingInvitations: [TripMember] = []
    var pastInvitations: [TripMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarDarkTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarDarkTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: .plain, target: self, action: #selector(inviteTapped))
        
        notificationTable.delegate = self
        notificationTable.dataSource = self
        
        // fakeNotifications()
        requestNotifications()
        notificationTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func requestNotifications() {
        if let user = PFUser.current() {
            ParseBackend.getInvitedTrips(user: user) {
                (tripMember, error) in
                if let tripMember = tripMember {
                    self.pendingInvitations = tripMember
                    DispatchQueue.main.async {
                        self.notificationTable.reloadData()
                    }
                } else {
                    print("Error to get invited trips \(error)")
                }
            }
            ParseBackend.getTripsCreatedByUser(user: user) {
                (trips, error) in
                if let trips = trips {
                    self.trips = trips
                    print("trips created by me: \(trips.count)")
                    ParseBackend.getTripMemberOnTrips(trips: trips) {
                        (tripMember, error) in
                        if let tripMember = tripMember {
                            self.pastInvitations = tripMember
                            DispatchQueue.main.async {
                                self.notificationTable.reloadData()
                            }
                        } else {
                            print("Error to get past invitations: \(error)")
                        }
                    }
                    self.notificationTable.reloadData()
                } else {
                    print("Error to get created trips: \(error)")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumInvitations(isPending: isPendingSection(section: section))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isPendingSection(section: indexPath.section)) {
            if (!isLast(indexPath: indexPath)) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pendingCell") as! PendingInvitationTableViewCell
                cell.displayInvitaion(tripMember: self.pendingInvitations[indexPath.row])
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "controlCell") as! NotificationControlTableViewCell
                cell.showStatus(more: expandPending)
                return cell
            }
        } else {
            if (!isLast(indexPath: indexPath)) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pastCell") as! HistoryInvitationTableViewCell
                cell.displayInvitaion(tripMember: self.pastInvitations[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "controlCell") as! NotificationControlTableViewCell
                cell.showStatus(more: expandPast)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (isPendingSection(section: section)) {
            return "RECEIVED"
        } else {
            return "SENT"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if (isLast(indexPath: indexPath)) {
            if (isPendingSection(section: indexPath.section)) {
                expandPending = !expandPending
            } else {
                expandPast = !expandPast
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isPendingSection(section: indexPath.section)) {
            if (!isLast(indexPath: indexPath)) {
                return 90.0
            } else {
                return 50.0
            }
        } else {
            return 50.0
        }
    }

    func inviteTapped(_ sender: Any) {
    }
    
    private func isPendingSection(section: Int) -> Bool {
        return section == 0
    }
    
    private func getNumInvitations(isPending: Bool) -> Int {
        if (isPending) {
            if (!expandPending && self.pendingInvitations.count > MAX_INVITATIONS) {
                return MAX_INVITATIONS + 1
            } else {
                return self.pendingInvitations.count + 1
            }
        } else {
            if (!expandPast && self.pastInvitations.count > MAX_INVITATIONS) {
                return MAX_INVITATIONS + 1
            } else {
                return self.pastInvitations.count + 1
            }
        }
    }
    
    private func isLast(indexPath: IndexPath) -> Bool {
        return indexPath.row == getNumInvitations(isPending: isPendingSection(section: indexPath.section)) - 1
    }
    
    private func fakeNotifications() {
        let user = PFUser.current()!
        
        for i in 0 ... 6 {
            let creator = PFUser()
            creator.username = "a\(i)"
            let date = Date()
            let trip = Trip.createTrip(name: "Trip\(i)", date: date, creator: creator)
            let tripMember = TripMember(user: user, isCreator: false, trip: trip)
            if (i % 3 == 0) {
                tripMember.status = InviteStatus.Pending.hashValue
            } else if (i % 3 == 1) {
                tripMember.status = InviteStatus.Confirmed.hashValue
            } else if (i % 3 == 2) {
                tripMember.status = InviteStatus.Rejected.hashValue
            }
            self.pendingInvitations.append(tripMember)
        }
        
        for i in 0 ... 6 {
            let invitee = PFUser()
            invitee.username = "b\(i)"
            let date = Date()
            let trip = Trip.createTrip(name: "Trip\(i)", date: date, creator: user)
            let tripMember = TripMember(user: invitee, isCreator: false, trip: trip)
            if (i % 3 == 0) {
                tripMember.status = InviteStatus.Pending.hashValue
            } else if (i % 3 == 1) {
                tripMember.status = InviteStatus.Confirmed.hashValue
            } else if (i % 3 == 2) {
                tripMember.status = InviteStatus.Rejected.hashValue
            }
            self.pastInvitations.append(tripMember)
        }
    }
    
    func confirmInvitation(index: Int) {
        self.pendingInvitations[index].status = InviteStatus.Confirmed.hashValue
        self.pendingInvitations[index].saveInBackground{ (success, error) in
            if success {
                log.info("Invitation \(index) confirmed")
            } else {
                guard let error = error else {
                    log.error("Unknown error occurred confirming invitations")
                    return
                }
                log.error("Error confirming invitations: \(error)")
            }
        }
    }
    
    func rejectInvitation(index: Int) {
        self.pendingInvitations[index].status = InviteStatus.Rejected.hashValue
        self.pendingInvitations[index].saveInBackground{ (success, error) in
            if success {
                log.info("Invitation \(index) rejected")
            } else {
                guard let error = error else {
                    log.error("Unknown error occurred rejecting invitations")
                    return
                }
                log.error("Error rejecting invitations: \(error)")
            }
        }
    }
}

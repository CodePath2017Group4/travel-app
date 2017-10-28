//
//  HistoryInvitationTableViewCell.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/28/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class HistoryInvitationTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayInvitaion(tripMember: TripMember) {
        if let tripName = tripMember.trip.name {
            if let username = tripMember.user.username {
                if (tripMember.status == InviteStatus.Confirmed.hashValue) {
                    statusLabel.text = "\(username) confirmed trip \(tripName)."
                } else if (tripMember.status == InviteStatus.Rejected.hashValue) {
                    statusLabel.text = "\(username) rejected trip \(tripName)."
                } else if (tripMember.status == InviteStatus.Pending.hashValue) {
                    statusLabel.text = "Waiting for \(username) to confirm trip \(tripName)."
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

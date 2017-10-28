//
//  PendingInvitationTableViewCell.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/28/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class PendingInvitationTableViewCell: UITableViewCell {

    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    var index: Int = 0
    var delegate: InvitationDelegate?
    
    func displayInvitaion(tripMember: TripMember) {
        let trip = tripMember.trip
        tripLabel.text = trip.name
        dateLabel.text = Utils.formatDate(date: trip.date)
        ownerLabel.text = trip.creator.username
        if (tripMember.status == InviteStatus.Pending.hashValue) {
            acceptButton.setImage(UIImage(named: "check-pending"), for: .normal)
            rejectButton.setImage(UIImage(named: "reject-pending"), for: .normal)
        } else if (tripMember.status == InviteStatus.Confirmed.hashValue) {
            acceptButton.setImage(UIImage(named: "check"), for: .normal)
            rejectButton.setImage(UIImage(named: "reject-pending"), for: .normal)
        } else if (tripMember.status == InviteStatus.Rejected.hashValue) {
            acceptButton.setImage(UIImage(named: "check-pending"), for: .normal)
            rejectButton.setImage(UIImage(named: "reject"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        acceptButton.setImage(UIImage(named: "check"), for: .normal)
        rejectButton.setImage(UIImage(named: "reject-pending"), for: .normal)
        if let delegate = self.delegate {
            delegate.confirmInvitation(index: self.index)
        }
    }
    
    @IBAction func rejectButtonTapped(_ sender: Any) {
        acceptButton.setImage(UIImage(named: "check-pending"), for: .normal)
        rejectButton.setImage(UIImage(named: "reject"), for: .normal)
        if let delegate = self.delegate {
            delegate.rejectInvitation(index: self.index)
        }
    }
    
}

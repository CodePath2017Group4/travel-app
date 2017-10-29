//
//  FriendUserCell.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/23/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import Parse

class FriendUserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var invitationStatus: UILabel!
    
    var user: PFUser! {
        didSet {
            avatarImageView.image = #imageLiteral(resourceName: "user")
            usernameLabel.text = user.username
            let avatarFile = user.object(forKey: "avatar") as? PFFile
            if avatarFile != nil {
                Utils.fileToImage(file: avatarFile!) { (image) in
                    self.avatarImageView.image = image
                }
            } else {
                avatarImageView.image = #imageLiteral(resourceName: "user")
            }
        }
    }
    
    func setStatus(onTrip: Int) {
        if (onTrip == InviteStatus.Pending.hashValue) {
            invitationStatus.text = "Invitation Status: Pending"
        } else if (onTrip == InviteStatus.Confirmed.hashValue) {
            invitationStatus.text = "Invitation Status: Confirmed"
        }  else if (onTrip == InviteStatus.Rejected.hashValue) {
            invitationStatus.text = "Invitation Status: Rejected"
        } else {
            invitationStatus.text = "No invitation sent before"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        avatarImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

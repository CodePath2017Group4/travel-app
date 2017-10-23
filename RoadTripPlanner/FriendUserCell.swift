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
    @IBOutlet weak var addRemoveButton: UIButton!
    
    var avatarFile: PFFile?
    
    var user: PFUser! {
        didSet {
            usernameLabel.text = user.username
            avatarFile = user.avatarFile
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let avatarFile = self.avatarFile else { return }
        Utils.fileToImage(file: avatarFile) { (image) in
            self.avatarImageView.image = image
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addRemoveButtonPressed(_ sender: Any) {
        
    }
}

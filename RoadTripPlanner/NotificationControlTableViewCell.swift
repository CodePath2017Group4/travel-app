//
//  NotificationControlTableViewCell.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/28/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class NotificationControlTableViewCell: UITableViewCell {

    @IBOutlet weak var controlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showStatus(more: Bool) {
        if (more) {
            controlLabel.text = "Show less"
        } else {
            controlLabel.text = "Show more"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

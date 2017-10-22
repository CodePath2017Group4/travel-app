//
//  TripSegmentCell.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/19/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class TripSegmentCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var includeSwitch: UISwitch!
    
    var tripSegment: TripSegment! {
        didSet {
            placeNameLabel.text = tripSegment.name
            placeAddressLabel.text = tripSegment.address
            distanceLabel.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeNameLabel.preferredMaxLayoutWidth = placeNameLabel.frame.size.width
        placeAddressLabel.preferredMaxLayoutWidth = placeAddressLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
    
    }
}
